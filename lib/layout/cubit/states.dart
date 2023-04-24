import 'package:firebase_core/firebase_core.dart';

abstract class AppStates {}

class AppInitalState extends AppStates {}

class ChangeIndexBottomNavState extends AppStates {}

class ChangeCheckState extends AppStates {}

class ChangeCategoryState extends AppStates {}

class ChangeRepeateCheckState extends AppStates {}

class FillSelectedDaysSuccessState extends AppStates {}

class AddSelectedDaysSuccessState extends AppStates {}

class RemoveSelectedDaysSuccessState extends AppStates {}

class AddPostSuccessState extends AppStates {}

class AddPostErrorState extends AppStates {
  String? error;
  AddPostErrorState(this.error);
}

class AddPostLoadingState extends AppStates {}

class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates {}

class GetTaskSuccessState extends AppStates {}

class GetTaskErrorState extends AppStates {
  FirebaseException error;
  GetTaskErrorState({
    required this.error,
  });
}

class GetTaskLoadingState extends AppStates {}

class SignOutSuccessState extends AppStates {}

class SignOutErrorState extends AppStates {}

class CacheClearErrorState extends AppStates {}

class DeletePostSuccessState extends AppStates {}

class DeletePostErrorState extends AppStates {
  TypeError? error;
  DeletePostErrorState(this.error);
}

class DeletePostLoadingState extends AppStates {}

class UpdatePostSuccessState extends AppStates {}

class UpdatePostErrorState extends AppStates {
  FirebaseException error;
  UpdatePostErrorState(this.error);
}

class UpdatePostLoadingState extends AppStates {}

class PostDoneLoadingState extends AppStates {}

class PostDoneSuccessState extends AppStates {}

class PostDoneErrorState extends AppStates {}

class SendPasswordResetSuccessState extends AppStates {}

class SendPasswordResetErrorState extends AppStates {}

class SendPasswordResetLoadingState extends AppStates {}

class IdNotificationSaveSuccessState extends AppStates {}

class CheckDatePassedState extends AppStates {}

class DeleteAllPostErrorState extends AppStates {
  TypeError? error;
  DeleteAllPostErrorState(this.error);
}

class AddNewCategorySuccessState extends AppStates {}

class DeleteNewCategorySuccessState extends AppStates {}

class GetSelectedTaskSuccessState extends AppStates {}

class GetSelectedTaskErrorState extends AppStates {
  FirebaseException error;
  GetSelectedTaskErrorState({
    required this.error,
  });
}

class GetSelectedTaskLoadingState extends AppStates {}

class SelectedCategorySuccessState extends AppStates {}

class GetAllCategoriesSuccessState extends AppStates {}

class GetAllCategoriesLoadingState extends AppStates {}

class UpdateUserErrorState extends AppStates {}

class UpdateUserSuccessState extends AppStates {}

class UpdateUserLoadingState extends AppStates {}

class UpdateUserEmailErrorState extends AppStates {}

class ItemTypeChangeSuccessState extends AppStates {}

class ItemTypeChangeErrorState extends AppStates {}

// After Notifications Course

class RequestPermissionSuccessState extends AppStates {}
