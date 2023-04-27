import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/layout/cubit/states.dart';
import 'package:my_reminder/layout/home_layout.dart';
import 'package:my_reminder/shared/components/components.dart';
import 'package:my_reminder/shared/components/constants.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var formKeyRepeate = GlobalKey<FormState>();
  DateTime? myDate;
  DateTime? pickedDate;
  String hint = 'اختر تصنيف';
  String? selectedCategory;
  bool isItemSelected = false;

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AddPostSuccessState) {
          navigateAndFinish(context, const HomeLayout());
        }
      },
      builder: (context, state) {
        // print(categoriesList);
        AppCubit cubit = AppCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 5.0,
              backgroundColor: Colors.blue[400],
              leading: IconButton(
                  onPressed: () {
                    isDatePassed = false;
                    navigateAndFinish(context, const HomeLayout());
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              title: const Text(
                'تذكيرة جديدة',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    textBaseline: TextBaseline.alphabetic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: defaultTextFormField(
                                    expandedField: true,
                                    controller: titleController,
                                    type: TextInputType.text,
                                    label: 'عنوان التذكيرة',
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return '*';
                                      }
                                      return null;
                                    }),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                height: 70.0,
                                child: defaultTextFormField(
                                    isNotEditalble: true,
                                    onFieldPress: () {
                                      showDatePicker(
                                              locale: const Locale('ar', 'SA'),
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(3000))
                                          .then((value) {
                                        initializeDateFormatting("ar_SA", null)
                                            .then((_) {
                                          dateController.text =
                                              intl.DateFormat.yMMMEd('ar_SA')
                                                  .format(value!);
                                          myDate =
                                              intl.DateFormat.yMMMEd('ar_SA')
                                                  .parse(dateController.text);

                                          DateTime checkerDate = DateTime(
                                            myDate!.year,
                                            myDate!.month,
                                            myDate!.day,
                                            pickedDate!.hour,
                                            pickedDate!.minute,
                                          );

                                          if (checkerDate
                                              .isBefore(pickedDate!)) {
                                            cubit.checkDate(true);
                                            toastMessage(
                                                message: 'لقد قمت بتعديل خاطئ');
                                          } else {
                                            cubit.checkDate(false);
                                          }
                                        });
                                      });
                                    },
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    label: 'التاريخ',
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return '*';
                                      }
                                      return null;
                                    }),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                height: 70.0,
                                child: defaultTextFormField(
                                    isNotEditalble: true,
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    label: 'الوقت',
                                    onFieldPress: () {
                                      if (dateController.text.isEmpty) {
                                        toastMessage(
                                            message:
                                                'يرجى اختيار التاريخ أولًا');
                                      } else {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          initializeDateFormatting(
                                                  "ar_SA", null)
                                              .then((_) {
                                            pickedDate = DateTime(
                                                myDate!.year,
                                                myDate!.month,
                                                myDate!.day,
                                                value!.hour,
                                                value.minute);

                                            if (pickedDate!
                                                .isBefore(DateTime.now())) {
                                              cubit.checkDate(true);
                                              toastMessage(message: 'وقت فائت');
                                            } else {
                                              cubit.checkDate(false);
                                              String minute = value.minute
                                                  .toString()
                                                  .padLeft(2, '0');

                                              timeController.text = intl
                                                      .DateFormat.Hm()
                                                  .parse(
                                                      '${value.hour}:$minute')
                                                  .toString()
                                                  .substring(11, 16);
                                            }
                                          });
                                        });
                                      }
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return '*';
                                      }
                                      return null;
                                    }),
                              ),
                              InkWell(
                                onTap: () {
                                  funRepeate(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[100],
                                      boxShadow: const [BoxShadow()]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 8.0),
                                    child: Row(
                                      children: const [
                                        // Checkbox(
                                        //     value: isRepeated,
                                        //     onChanged: (value) {
                                        //       cubit.changeRepeateCheck(value);
                                        //     }),
                                        Text('تكرار'),
                                        Spacer(),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: isCategorySelected,
                                      onChanged: (value) {
                                        cubit.changeCategoryCheck(value);
                                      }),
                                  const Text('إضافة التذكيرة في تصنيف جديد')
                                ],
                              ),
                              if (isCategorySelected)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton(
                                      value: categoriesList!
                                              .contains(cubit.selectedCategory)
                                          ? cubit.selectedCategory
                                          : null,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      hint: Text(hint),
                                      items: List<String>.from(
                                              categoriesList as List)
                                          .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        cubit.selectCategory(
                                            categoryName: value!);
                                      }),
                                ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ConditionalBuilder(
                                      condition: state is! AddPostLoadingState,
                                      builder: (context) => defaultButton(
                                          text: 'إضافة',
                                          onPressFunction: isDatePassed != true
                                              ? () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    isCategoryClicked = false;
                                                    // DateTime? newTime;
                                                    DateTime newDt =
                                                        intl.DateFormat.yMMMEd(
                                                                'ar_SA')
                                                            .parse(
                                                                dateController
                                                                    .text);

                                                    DateTime newTime =
                                                        intl.DateFormat('H:mm')
                                                            .parse(
                                                                timeController
                                                                    .text);

                                                    DateTime dt = DateTime(
                                                        newDt.year,
                                                        newDt.month,
                                                        newDt.day,
                                                        newTime.hour,
                                                        newTime.minute);
                                                    if (!isCategorySelected) {
                                                      cubit.addTask(
                                                        title: titleController
                                                            .text,
                                                        date:
                                                            dateController.text,
                                                        time:
                                                            timeController.text,
                                                        lastUpdate: dt,
                                                      );
                                                    }
                                                    if (isCategorySelected &&
                                                        cubit.selectedCategory!
                                                            .isNotEmpty) {
                                                      cubit.addTask(
                                                          title: titleController
                                                              .text,
                                                          date: dateController
                                                              .text,
                                                          time: timeController
                                                              .text,
                                                          lastUpdate: dt,
                                                          type: cubit
                                                              .selectedCategory);
                                                    }
                                                  }
                                                }
                                              : null,
                                          color: isDatePassed
                                              ? Colors.grey
                                              : Colors.blue),
                                      fallback: (context) => const Center(
                                          child: CircularProgressIndicator()),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
