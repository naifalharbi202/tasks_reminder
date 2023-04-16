import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/layout/cubit/states.dart';
import 'package:my_reminder/modules/login/cubit/cubit.dart';
import 'package:my_reminder/modules/login/cubit/states.dart';
import 'package:my_reminder/shared/components/components.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    defaultTextFormField(
                        style: Theme.of(context).textTheme.bodyText1,
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        label: 'البريد الإلكتروني',
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'أدخل البريد الإلكتروني';
                          }
                          return null;
                        },
                        prefixIcon: Icons.email_outlined),
                    const SizedBox(
                      height: 15.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! SendPasswordResetLoadingState,
                      builder: (context) => defaultButton(
                          radius: 0.0,
                          text: 'استعادة',
                          onPressFunction: () {
                            if (formKey.currentState!.validate()) {
                              AppCubit.get(context).forgetPassword(
                                  email: emailController.text.trim());
                            }
                          }),
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
