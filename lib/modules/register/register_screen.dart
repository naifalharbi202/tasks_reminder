import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/layout/home_layout.dart';
import 'package:my_reminder/modules/login/cubit/cubit.dart';
import 'package:my_reminder/modules/login/login_screen.dart';
import 'package:my_reminder/modules/register/cubit/cubit.dart';
import 'package:my_reminder/modules/register/cubit/states.dart';
import 'package:my_reminder/shared/components/components.dart';
import 'package:my_reminder/shared/components/constants.dart';
import 'package:my_reminder/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>(); // validation
  double height = 50.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if (state is CreateUserSuccessState) {
              CacheHelper.saveData(key: 'uId', value: state.uid).then((value) {
                uId = state.uid;
                AppCubit.get(context).changeDefaultList();
                navigateAndFinish(context, HomeLayout());
              });
            }
          },
          builder: (context, state) {
            RegisterCubit cubit = RegisterCubit.get(context);
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(),
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'تسجيل جديد',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            height: 70.0,
                            child: defaultTextFormField(
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
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 70.0,
                            child: defaultTextFormField(
                                prefixIcon: Icons.email,
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                label: 'البريد الإلكتروني',
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'أدخل البريد الإلكتروني';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 70,
                            child: defaultTextFormField(
                                onChange: (value) {
                                  cubit.isPasswordUnderSix(value);
                                },
                                isPassword:
                                    RegisterCubit.get(context).isPassword,
                                prefixIcon: Icons.lock,
                                suffixIcon:
                                    RegisterCubit.get(context).suffixIcon,
                                onSuffixPress: () {
                                  RegisterCubit.get(context)
                                      .showPasswordVisibility();
                                },
                                controller: passwordController,
                                type: TextInputType.visiblePassword,
                                label: 'كلمة المرور',
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'أدخل كلمة المرور';
                                  }
                                  return null;
                                }),
                          ),
                          if (cubit.isPassUnderSix == true)
                            Container(
                              width: double.infinity,
                              color: Colors.red[500],
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                          SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            height: 70,
                            child: defaultTextFormField(
                                prefixIcon: Icons.phone,
                                controller: phoneController,
                                type: TextInputType.phone,
                                label: 'رقم الهاتف',
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'أدخل رقم الهاتف';
                                  }
                                  return null;
                                }),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder: (context) => defaultButton(
                                text: 'تسجيل',
                                onPressFunction: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.registerUser(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text);
                                  }
                                }),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),
                          SizedBox(
                            height: 25.0,
                          ),
                          TextButton(
                              onPressed: () {
                                navigateAndFinish(context, LoginScreen());
                              },
                              child: Text('هل تمتلك حساب؟ '))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
