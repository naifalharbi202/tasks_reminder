import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String? uId; // to save it

  LoginSuccessState(this.uId);
}

class LoginLoadingState extends LoginStates {}

class LoginErorrState extends LoginStates {
  final FirebaseAuthException? error;

  LoginErorrState(this.error);
}

class LoginShowPasswordState extends LoginStates {}

class PasswordChangeState extends LoginStates {}

class GetNotificationsSucessState extends LoginStates {}

class GetNotificationsErrorState extends LoginStates {}
