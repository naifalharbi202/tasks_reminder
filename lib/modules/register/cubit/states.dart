import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterShowPasswordState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  FirebaseAuthException? error;
  RegisterErrorState(this.error);
}

class RegisterLoadingState extends RegisterStates {}

class CreateUserSuccessState extends RegisterStates {
  String? uid;
  CreateUserSuccessState(this.uid);
}

class CreateUserErrorState extends RegisterStates {
  String? error;
  CreateUserErrorState(this.error);
}

class CreateUserLoadingState extends RegisterStates {}

class CreateUserGetTokenSuccesState extends RegisterStates {}

class CreateUserGetTokenErrorState extends RegisterStates {}

class CreateUserGetTokenLoadingState extends RegisterStates {}

class PasswordChangeState extends RegisterStates {}
