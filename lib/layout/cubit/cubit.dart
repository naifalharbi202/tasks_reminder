﻿import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/layout/cubit/states.dart';
import 'package:my_reminder/models/task_model.dart';
import 'package:my_reminder/models/user_model.dart';
import 'package:my_reminder/modules/done_tasks/done_tasks_screen.dart';
import 'package:my_reminder/modules/new_tasks/new_tasks_screen.dart';
import 'package:my_reminder/modules/settings/settings_screen.dart';
import 'package:my_reminder/shared/components/constants.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../shared/components/components.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/local/notification_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitalState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    SettingsScreen(),
  ];

  List<String> titles = ['تذكيرات', ' مُنجزة', 'صفحة المستخدم'];

  // request sending notification
  void requestPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
        emit(RequestPermissionSuccessState());
      }
    });
  }

  void changeBottomNavIndex(index) {
    currentIndex = index;
    emit(ChangeIndexBottomNavState());
  }

  UserModel? userModel;
  //Get One User
  void getUser() {
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data());

      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState());
    });
  }

  int lastId = CacheHelper.getData('lastId') ?? 1;

  TaskModel? taskModel;
  void addTask({
    required String title,
    required String date,
    required String time,
    required DateTime lastUpdate,
    String? type,
  }) async {
    emit(AddPostLoadingState());

    taskModel = TaskModel(
      taskTitle: title,
      taskDate: date,
      taskTime: time,
      name: userModel!.name,
      uid: userModel!.uId,
      lastUpdated: lastUpdate,
      isDone: false,
      notificationId: lastId,
      type: type ?? 'default',
      /*taskId: lastId.toString()*/
    );

    var ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('tasks')
        .doc(lastId.toString());

    ref.set(taskModel!.toJson()).then((value) {
      // Repeated notification //

      if (isRepeated) {
        NotificationHelper.cancelScheduled();
        for (int i = 0; i < dayNumbers.length; i++) {
          NotificationHelper.repeateNotification(
            id: lastId++,
            title: title,
            body: 'Repeated Notification',
            day: i,
            dateTime: lastUpdate,
          );
          print('day number ============= $i');
        }

        isRepeated = false;
        print('I am in is repeated');
      }
      // Not repeated notification //
      else {
        NotificationHelper.triggerNotification(
            id: lastId++,
            title: title,
            body: 'New notification',
            dateTime: lastUpdate);
        print('I am not repeated');
      }
      print('---------------------$isRepeated');
      CacheHelper.saveData(key: 'lastId', value: lastId).then((value) {
        emit(AddPostSuccessState());
      });
    }).catchError((error) {
      emit(AddPostErrorState(error));
    });
  }

  Future<void> getTask({String? type}) async {
    emit(GetTaskLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('tasks')
        .orderBy('lastUpdated')
        .snapshots()
        .listen((value) {
      tasks = [];
      doneTasks = [];
      selectedTasks = [];
      for (var element in value.docs) {
        // Save the data of all documents in data var
        var data = element.data();
        // Add element.id to this data because it refers to the autogenerated doc id and I don't have it
        data['taskId'] = element.id;
        // Recieve timestamp, turn it into date time
        data['lastUpdated'] = DateTime.fromMillisecondsSinceEpoch(
            data['lastUpdated'].seconds * 1000);

        // After that fill the task with this data (including doc id)

        if (data['isDone'] == false) {
          tasks.add(TaskModel.fromJson(data));
        } else {
          doneTasks.add(TaskModel.fromJson(data));
        }

        if (data['type'] == type &&
            data['type'] != 'default' &&
            data['isDone'] == false) {
          selectedTasks.add(TaskModel.fromJson(data));
        }
      }

      emit(GetTaskSuccessState());
    });
    // .catchError((error) {
    //   print(error.toString());
    //   emit(GetTaskErrorState(error: error));
    // });
  }

  void deleteTask({required taskId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('tasks')
        .doc(taskId)
        .delete()
        .then((value) {
      NotificationHelper.deleteNotification(id: int.parse(taskId)); //

//getTask();
    }).catchError((error) {
      emit(DeletePostErrorState(error));
    });
  }

  void updateTask({
    required taskId,
    title,
    date,
    time,
    required DateTime lastUpdate,
  }) {
    emit(UpdatePostLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('tasks')
        .doc(taskId)
        .update({
      'taskDate': date,
      'taskTitle': title,
      'taskTime': time,
      'lastUpdated': lastUpdate,
      'isDone': false,
    }).then((value) {
      NotificationHelper.deleteNotification(id: int.parse(taskId))
          .then((value) {
        NotificationHelper.triggerNotification(
            id: int.parse(taskId),
            title: title,
            body: 'يوجد لديك تذكيرة جديدة',
            dateTime: lastUpdate);
        emit(UpdatePostSuccessState());
        //getTask();
      });
    }).catchError((error) {
      UpdatePostErrorState(error);
    });
  }

////

  void signOut(context, Widget destination) async {
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData('uId').then((value) {
        // NotificationHelper.cancelAllNotifications();

        navigateAndFinish(context, destination);
        emit(SignOutSuccessState());
      });
    }).catchError((error) {
      emit(SignOutErrorState());
    });
  }

  // Done Tasks //

  void changeCheck(value) {
    !value;

    emit(ChangeCheckState());
  }

  void doneTask({
    required taskId,
  }) {
    emit(PostDoneLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('tasks')
        .doc(taskId)
        .update({'isDone': true}).then(
      (value) {
        emit(PostDoneSuccessState());
      },
    ).catchError((error) {
      emit(PostDoneErrorState());
    });
  }

  void forgetPassword({required email}) {
    emit(SendPasswordResetLoadingState());

    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      toastMessage(message: 'تم ارسال الرسالة');
      emit(SendPasswordResetSuccessState());
    }).catchError((error) {
      toastMessage(message: 'حدث خطأ');
      emit(SendPasswordResetErrorState());
    });
  }

  void checkDate(value) {
    isDatePassed = value;
    emit(CheckDatePassedState());
  }

  void changeRepeateCheck(value) {
    isRepeated = value;
    print(value);
    emit(ChangeRepeateCheckState());
  }

  void changeCategoryCheck(value) {
    isCategorySelected = value;

    emit(ChangeCategoryState());
  }

  String? selectedCategory;
  void selectCategory({required String categoryName}) {
    selectedCategory = categoryName;
    emit(SelectedCategorySuccessState());
  }

  void getCategories() {
    emit(GetAllCategoriesSuccessState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      categoriesList = [];
      var data = value.data();
      categoriesList = data!['categories'];
      emit(GetAllCategoriesSuccessState());
//getTask();
    });
  }

  void addNewCategory({required String? categoryName}) {
    categoriesList!.add(categoryName);
    FirebaseFirestore.instance.collection('users').doc(uId).set(
        {'categories': categoriesList}, SetOptions(merge: true)).then((value) {
      emit(AddNewCategorySuccessState());
      getCategories();
    });
  }

  void deleteSelectedCategory({required int index}) {
    categoriesList!.removeAt(index);
    FirebaseFirestore.instance.collection('users').doc(uId).set(
        {'categories': categoriesList!}, SetOptions(merge: true)).then((value) {
      emit(DeleteNewCategorySuccessState());
      getCategories();
    });
  }

  void changeDeltedItemToDefault(String deletedCategoryName) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('tasks')
        .get()
        .then((value) {
      for (var element in value.docs) {
        var data = element.data();
        if (data['type'] == deletedCategoryName) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(uId)
              .collection('tasks')
              .doc(element.id)
              .set({'type': 'default'}, SetOptions(merge: true)).then((value) {
            emit(ItemTypeChangeSuccessState());
          });
        }
      }
    }).catchError((error) {
      emit(ItemTypeChangeErrorState());
    });
  }

  void changeDefaultList() {
    categoriesList = defaultCategories;

    getUser();
  }

  void updateUser({
    String? name,
    String? phone,
  }) {
    emit(UpdateUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).set({
      'name': name,
      'phone': phone,
    }, SetOptions(merge: true)).then((value) {
      toastMessage(message: 'تم التحديث بنجاح');
      getUser();
      emit(UpdateUserSuccessState());
    }).catchError((error) {
      emit(UpdateUserErrorState());
    });
  }

  List<String> selectedItems = [];

  void fillSelectedDays(List<String> value) {
    selectedItems = value;
    emit(FillSelectedDaysSuccessState());
  }

  void addToSelectedDays(String day) {
    selectedItems.add(day);
    emit(AddSelectedDaysSuccessState());
  }

  void removeFromSelectedDays(String day) {
    selectedItems.remove(day);
    emit(RemoveSelectedDaysSuccessState());
  }
}
