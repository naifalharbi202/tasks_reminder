import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/layout/home_layout.dart';
import 'package:my_reminder/modules/login/cubit/cubit.dart';
import 'package:my_reminder/modules/login/cubit/states.dart';
import 'package:my_reminder/modules/login/forgot_pass_screen.dart';
import 'package:my_reminder/modules/register/register_screen.dart';
import 'package:my_reminder/shared/components/components.dart';
import 'package:my_reminder/shared/network/local/cache_helper.dart';

import '../../shared/components/constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>(); // validation

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: ((context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = state.uId;
            }).then((value) {
              AppCubit.get(context).currentIndex = 0;
              AppCubit.get(context).getUser();
              AppCubit.get(context).getCategories();
              navigateAndFinish(context, HomeLayout());
            });
          }
        }),
        builder: ((context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تسجيل دخول',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    // color: Colors.black,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
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
                            defaultTextFormField(
                                onChange: (value) {
                                  cubit.isPasswordUnderSix(value);
                                },
                                style: Theme.of(context).textTheme.bodyText1,
                                controller: passwordController,
                                type: TextInputType.visiblePassword,
                                label: 'كلمة المرور',
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'أدخل كلمة المرور';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: cubit.suffixIcon,
                                isPassword: cubit.isPassword,
                                onSuffixPress: () {
                                  cubit.showPasswordVisibility();
                                },
                                onFieldSubmitted: (value) {
                                  if (formKey.currentState!.validate()) {}
                                }),
                            const SizedBox(
                              height: 2.0,
                            ),
                            if (cubit.isPassUnderSix == true)
                              Container(
                                width: double.infinity,
                                color: Colors.red[500],
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'أقل عدد خانات هو 6',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            ConditionalBuilder(
                              condition: state is! LoginLoadingState,
                              builder: (context) => defaultButton(
                                  radius: 0.0,
                                  text: 'تسجيل الدخول',
                                  onPressFunction: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.loginUser(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  }),
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextButton(
                                      onPressed: () {
                                        navigatTo(
                                            context, ForgetPasswordScreen());
                                      },
                                      child: const Text('نسيت كلمة المرور؟')),
                                ),
                                Expanded(
                                  child: TextButton(
                                      onPressed: () {
                                        navigateAndFinish(
                                            context, RegisterScreen());
                                      },
                                      child: const Text('مستخدم جديد؟')),
                                )
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
