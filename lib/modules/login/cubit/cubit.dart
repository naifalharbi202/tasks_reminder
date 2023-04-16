import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/modules/login/cubit/states.dart';
import 'package:my_reminder/shared/components/components.dart';
import 'package:my_reminder/shared/components/constants.dart';
import 'package:my_reminder/shared/network/local/notification_helper.dart';

import '../../../../shared/network/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off;

  void showPasswordVisibility() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(LoginShowPasswordState());
  }

  void loginUser({required String email, required String password}) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      if (error.runtimeType == FirebaseAuthException ||
          error.runtimeType == FirebaseException ||
          error.runtimeType == AssertionError) {
        toastMessage(
            message: 'يرجى التأكد من صحة البريد الإلكتروني أو كلمة المرور');
        emit(LoginErorrState(error));
      }

      emit(LoginErorrState(error));
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

  // void getNotificationsAfterLogIn(context) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uId)
  //       .collection('tasks')
  //       .get()
  //       .then((value) {
  //     for (var element in value.docs) {
  //       var data = element.data();
  //       var notificationId = data['notificationId'];
  //       var title = data['title'];
  //       if (data['lastUpdated'].isAfter(DateTime.now())) {
  //         NotificationHelper.showNotification(
  //             notificationId, title, 'رجعنا لك تذكيرتك', data['lastUpdated']);
  //         // emit(GetNotificationsSucessState());
  //       }
  //       AppCubit.get(context).getTask();
  //     }
  //   }).catchError((error) {
  //     toastMessage(message: error.toString());
  //     print(error.toString());
  //     emit(GetNotificationsErrorState());
  //   });
  // }
}
