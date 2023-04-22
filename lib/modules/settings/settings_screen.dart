import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/layout/cubit/states.dart';
import 'package:my_reminder/modules/login/login_screen.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    nameController.text = AppCubit.get(context).userModel!.name.toString();
    emailController.text = AppCubit.get(context).userModel!.email.toString();
    phoneController.text = AppCubit.get(context).userModel!.phone.toString();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(children: [
                  defaultTextFormField(
                      prefixIcon: Icons.person,
                      controller: nameController,
                      type: TextInputType.name,
                      label: 'أسم المستخدم',
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'أدخل أسم المستخدم';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  defaultTextFormField(
                      prefixIcon: Icons.phone,
                      controller: phoneController,
                      type: TextInputType.name,
                      label: 'رقم الهاتف',
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'رقم الهاتف';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ConditionalBuilder(
                          condition: state is! UpdateUserLoadingState,
                          builder: (context) => defaultButton(
                              text: 'تحديث',
                              onPressFunction: () {
                                if (formKey.currentState!.validate()) {
                                  if (nameController.text ==
                                          AppCubit.get(context)
                                              .userModel!
                                              .name
                                              .toString() &&
                                      phoneController.text ==
                                          AppCubit.get(context)
                                              .userModel!
                                              .phone
                                              .toString() &&
                                      emailController.text ==
                                          AppCubit.get(context)
                                              .userModel!
                                              .email
                                              .toString()) {
                                    toastMessage(message: 'لا يوجد أي تحديث');
                                  } else {
                                    AppCubit.get(context).updateUser(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                }
                              }),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      SizedBox(
                        width: 50.0,
                      ),
                      Expanded(
                        child: defaultButton(
                            text: 'تسجيل خروج',
                            onPressFunction: () {
                              isCategoryClicked = false;
                              cubit.signOut(context, LoginScreen());
                            }),
                      )
                    ],
                  )
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
