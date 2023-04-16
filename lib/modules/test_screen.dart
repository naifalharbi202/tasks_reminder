import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_reminder/shared/components/components.dart';

class TestScreen extends StatefulWidget {
  TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var describtionController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  triggerNotification(
      {required String title,
      required String body,
      required DateTime dateTime}) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'main_channel',
          title: title,
          body: body,
        ),
        schedule: NotificationCalendar.fromDate(date: dateTime));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  defaultTextFormField(
                      controller: titleController,
                      type: TextInputType.text,
                      label: 'Title',
                      validate: (value) {
                        if (value!.isEmpty) {
                          return '##';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultTextFormField(
                      controller: describtionController,
                      type: TextInputType.text,
                      label: 'Describtion',
                      validate: (value) {
                        if (value!.isEmpty) {
                          return '##';
                        }
                        return null;
                      }),
                  defaultTextFormField(
                      isNotEditalble: true,
                      onFieldPress: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(3000))
                            .then((value) {
                          dateController.text =
                              DateFormat.yMMMd().format(value!);
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
                  defaultTextFormField(
                      isNotEditalble: true,
                      controller: timeController,
                      type: TextInputType.datetime,
                      label: 'الوقت',
                      onFieldPress: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((value) {
                          // String minute = value!.minute
                          //     .toString()
                          //     .padLeft(2, '0');
                          // timeController.text =
                          //     '${value.hour}:$minute}';

                          timeController.text =
                              value!.format(context).toString();
                        });
                      },
                      validate: (value) {
                        if (value!.isEmpty) {
                          return '*';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  defaultButton(
                      text: 'SEND Notification',
                      onPressFunction: () {
                        //  triggerNotification();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
