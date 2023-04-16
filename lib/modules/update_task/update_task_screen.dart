import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_reminder/models/task_model.dart';
import 'package:my_reminder/shared/components/constants.dart';
import '../../layout/cubit/states.dart';
import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';

class UpdateTaskScreen extends StatelessWidget {
  UpdateTaskScreen({super.key, required this.model});

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  TaskModel? model;
  DateTime? myDate;
  DateTime? pickedDate;

  @override
  Widget build(BuildContext context) {
    // toastMessage(message: 'I am in build nooo');
    titleController.text = model!.taskTitle.toString();
    dateController.text = model!.taskDate.toString();
    timeController.text = model!.taskTime.toString();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UpdatePostSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        //Builder is called repeteadly

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
                    navigateAndFinish(context, HomeLayout());
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              title: const Text(
                'تعديل تذكيرة',
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
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                              Container(
                                height: 70.0,
                                child: defaultTextFormField(
                                    isNotEditalble: true,
                                    onChange: (value) {
                                      // dateController.text = model!.taskDate!;
                                    },
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
                                          if (pickedDate == null) {
                                            DateTime checkerDate = DateTime(
                                              myDate!.year,
                                              myDate!.month,
                                              myDate!.day,
                                              DateTime.now().hour,
                                              DateTime.now().minute,
                                            );

                                            if (checkerDate
                                                .isBefore(DateTime.now())) {
                                              cubit.checkDate(true);
                                              toastMessage(
                                                  message: 'يرجى تعديل الوقت');
                                            } else {
                                              cubit.checkDate(false);
                                            }
                                          } else {
                                            DateTime checkerDate = DateTime(
                                              myDate!.year,
                                              myDate!.month,
                                              myDate!.day,
                                              pickedDate!.hour,
                                              pickedDate!.minute,
                                            );

                                            if (checkerDate
                                                .isBefore(DateTime.now())) {
                                              cubit.checkDate(true);
                                              toastMessage(
                                                  message: 'يرجى تعديل الوقت');
                                            } else {
                                              cubit.checkDate(false);
                                            }
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
                              Container(
                                height: 70.0,
                                child: defaultTextFormField(
                                    isNotEditalble: true,
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    label: 'الوقت',
                                    onFieldPress: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        initializeDateFormatting("ar_SA", null)
                                            .then((_) {
                                          if (model!.taskDate ==
                                              dateController.text) {
                                            pickedDate = DateTime(
                                                model!.lastUpdated!.year,
                                                model!.lastUpdated!.month,
                                                model!.lastUpdated!.day,
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
                                          } else {
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
                                          }
                                        });
                                      });
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return '*';
                                      }
                                      return null;
                                    }),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ConditionalBuilder(
                                      condition:
                                          state is! UpdatePostLoadingState,
                                      builder: (context) => defaultButton(
                                          text: 'تعديل',
                                          onPressFunction: isDatePassed != true
                                              ? () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    if (titleController.text ==
                                                            model!.taskTitle &&
                                                        dateController.text ==
                                                            model!.taskDate &&
                                                        timeController.text ==
                                                            model!.taskTime) {
                                                      toastMessage(
                                                          message:
                                                              'لا يوجد تعديل');
                                                    } else {
                                                      DateTime newDt = intl
                                                                  .DateFormat
                                                              .yMMMEd('ar_SA')
                                                          .parse(dateController
                                                              .text);

                                                      DateTime newTime =
                                                          intl.DateFormat(
                                                                  'H:mm')
                                                              .parse(
                                                                  timeController
                                                                      .text);

                                                      DateTime dt = DateTime(
                                                          newDt.year,
                                                          newDt.month,
                                                          newDt.day,
                                                          newTime.hour,
                                                          newTime.minute);
                                                      cubit.updateTask(
                                                        taskId: model!.taskId,
                                                        title: titleController
                                                            .text,
                                                        date:
                                                            dateController.text,
                                                        time:
                                                            timeController.text,
                                                        lastUpdate: dt,
                                                      );
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
