import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/models/user_model.dart';
import 'package:my_reminder/modules/register/cubit/states.dart';
import 'package:my_reminder/shared/components/components.dart';
import 'package:my_reminder/shared/components/constants.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  //Default values to listen to and change
  bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off;

  void showPasswordVisibility() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(RegisterShowPasswordState());
  }

  // Get Token
  // void getToken() {
  //   FirebaseMessaging.instance.getToken().then((value) {
  //     token = value;
  //     emit(CreateUserGetTokenSuccesState());
  //   }).catchError((error) {
  //     print('error getting token');
  //     emit(CreateUserGetTokenErrorState());
  //   });
  // }
// Create an instance from FirebaseMessaging
  var fcm = FirebaseMessaging.instance;

// Request permission on iOS devices .. step not needed for android
  void requestPermission() async {
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

// https://firebase.flutter.dev/docs/messaging/usage

// Handling messages

// Based on your application's current state, incoming payloads require different implementations to handle them: //

// Methods to handle incoming payloads depending on current application's state //

// OnMessage - Foreground State
// OnBackgroundMessage - Bakground & Terminated state

// Listen to message when app is in use
  void onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

// Listen to message when app is in background/terminated
  // 1- It must not be an anonymous function.
  // 2- It must be a top-level function (e.g. not a class method which requires initialization)

  // Put it in the main //

  // تسجيل المستخدم
  // get Token
  var fbm = FirebaseMessaging.instance.getToken().then((value) {
    token = value;
    // dkYcKVrCQf6KNOa0_SxLpB:APA91bH0jxOsrbjQ3JLYX1viTzq7xH5LlgQ5kZmiwNui-49nFPjAdZ0xGRKSKDGZsSTLTE0s6IWpROKGWwQAsW4WhwqDUWD5w4vByvLz6iHW1vQ7wxa9DPs3kLJzUEH6qNq7j1wPZDAL //
  });

  void registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        uid: value.user!.uid,
        categories: defaultCategories,
        token: token,
      );
    }).catchError((error) {
      toastMessage(message: error.toString());
      emit(RegisterErrorState(error));
    });
  }

  // حفظ بيانات المستخدم في قاعدة البيانات
  void createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String uid,
    required List<dynamic>? categories,
    required String? token,
  }) {
    UserModel userModel =
        UserModel(name, email, password, phone, uid, categories, token);

    // أنشئ مجموعة بأسم يوزرز في قاعدة البيانات
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userModel.toJson())
        .then((value) {
      emit(CreateUserSuccessState(uid));
    }).catchError((error) {
      toastMessage(message: error.toString());
      emit(CreateUserErrorState(error));
    });
  }

  bool? isPassUnderSix;
  void isPasswordUnderSix(value) {
    if (value.length < 6) {
      isPassUnderSix = true;
    } else {
      isPassUnderSix = false;
    }
    emit(PasswordChangeState());
  }
}

// it is  important to establish the various states a device can be in:
// 1- Foreground   // Open - in use
// 2- Background  // Minimised
// 3- Terminated  // When the device is locked or the application is not running.
