import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/modules/update_task/update_task_screen.dart';
import 'package:my_reminder/shared/components/constants.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/task_model.dart';

Widget defaultButton({
  @required String? text,
  @required Function()? onPressFunction,
  double width = double.infinity,
  Color color = Colors.blue,
  double radius = 10.0,
}) =>
    Container(
      width: width,
      padding: const EdgeInsets.symmetric(
        horizontal: 2.0,
      ),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(radius)),
      child: MaterialButton(
          onPressed: onPressFunction,
          child: Text(
            text!.toUpperCase(),
            style: const TextStyle(
              fontSize: 18.0,
              color: Color.fromARGB(255, 249, 247, 247),
            ),
          )),
    );

Widget defaultTextFormField({
  isNotEditalble = false,
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required FormFieldValidator<String>? validate,
  void Function()? onFieldPress,
  void Function(String)? onChange,
  void Function(String)? onFieldSubmitted,
  IconData? prefixIcon,
  IconData? suffixIcon,
  bool isPassword = false,
  TextStyle? style,
  void Function()? onSuffixPress,
  Color prefixIconColor = Colors.blue,
  bool expandedField = false,
}) =>
    Container(
      child: TextFormField(
        readOnly: isNotEditalble,
        maxLines: expandedField ? null : 1,
        style: style,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChange,
        validator: validate,
        controller: controller,
        onTap: onFieldPress,
        keyboardType: type,
        obscureText: isPassword,
        decoration: InputDecoration(
            isDense: true,
            labelText: label,
            prefixIcon: Icon(
              prefixIcon,
              color: prefixIconColor,
            ),
            suffixIcon: IconButton(
                icon: Icon(
                  suffixIcon,
                ),
                onPressed: onSuffixPress),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: const OutlineInputBorder()),
      ),
    );

void navigatTo(context, Widget destination) => Navigator.push(
    context, MaterialPageRoute(builder: (context) => destination));

//Will nav to next screen but without back arrow
void navigateAndFinish(context, newRoute) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => newRoute), (route) {
      return false;
    });

void toastMessage({
  required String message,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);

DateTime pickedDate = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

// Task item - long -
Widget buildTaskItem(TaskModel model, context) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (model.lastUpdated!.day == DateTime.now().day &&
                model.lastUpdated!.month == DateTime.now().month &&
                DateTime.now().year == model.lastUpdated!.year &&
                (((model.lastUpdated!.hour == DateTime.now().hour) &&
                        (model.lastUpdated!.minute >= DateTime.now().minute)) ||
                    ((model.lastUpdated!.hour > DateTime.now().hour) &&
                        (model.lastUpdated!.minute >= 0))))
              // intl.DateFormat.yMMMEd('ar_SA').format(pickedDate))

              const Text(
                ' اليوم :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
            if (model.lastUpdated!.day == DateTime.now().day &&
                    model.lastUpdated!.month == DateTime.now().month &&
                    DateTime.now().year == model.lastUpdated!.year &&
                    (model.lastUpdated!.hour >= DateTime.now().hour &&
                        model.lastUpdated!.minute >= DateTime.now().minute) ||
                model.lastUpdated!.isAfter(DateTime.now()))
              Dismissible(
                key: Key(model.taskId.toString()),
                onDismissed: (direction) => AppCubit.get(context).deleteTask(
                  taskId: model.taskId,
                ),
                child: InkWell(
                  onLongPress: () {
                    Share.share('''
                        ${model.taskTitle.toString()} 
                        ${model.taskDate.toString()}    ${model.taskTime.toString()} 
                        ''');
                  },
                  child: Container(
                    child: Card(
                      elevation: 8.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Checkbox(
                                  value: model.isDone,
                                  onChanged: (value) {
                                    model.isDone = value!;

                                    AppCubit.get(context)
                                        .changeCheck(model.isDone);
                                    if (model.isDone) {
                                      AppCubit.get(context)
                                          .doneTask(taskId: model.taskId);
                                    }
                                  }),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${model.taskTitle}',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                textBaseline: TextBaseline.ideographic,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${model.taskDate}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey[500]),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  Expanded(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Text(
                                        '${model.taskTime}',
                                        style: const TextStyle(
                                            fontSize: 13.9,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      onPressed: () {
                                        //k  toastMessage( message: model.taskId.toString());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateTaskScreen(
                                                      model: model,
                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.indigo[400],
                                        size: 25.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            if (model.lastUpdated!.isBefore(pickedDate) ||
                model.lastUpdated!.day == DateTime.now().day &&
                    model.lastUpdated!.month == DateTime.now().month &&
                    DateTime.now().year == model.lastUpdated!.year &&
                    (((model.lastUpdated!.hour == DateTime.now().hour) &&
                            (model.lastUpdated!.minute <
                                DateTime.now().minute)) ||
                        ((model.lastUpdated!.hour < DateTime.now().hour) &&
                            (model.lastUpdated!.minute >= 0))))

              // intl.DateFormat.yMMMEd('ar_SA').format(pickedDate))

              const Text(
                'تذكيرة فائتة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
            if (model.lastUpdated!.isBefore(pickedDate) ||
                model.lastUpdated!.day == DateTime.now().day &&
                    model.lastUpdated!.month == DateTime.now().month &&
                    DateTime.now().year == model.lastUpdated!.year &&
                    ((((model.lastUpdated!.hour == DateTime.now().hour) &&
                            (model.lastUpdated!.minute <
                                DateTime.now().minute)) ||
                        ((model.lastUpdated!.hour < DateTime.now().hour) &&
                            (model.lastUpdated!.minute >= 0)))))
              Dismissible(
                key: Key(model.taskId.toString()),
                onDismissed: (direction) =>
                    AppCubit.get(context).deleteTask(taskId: model.taskId),
                child: InkWell(
                  onLongPress: () {
                    Share.share(
                        '${model.taskTitle.toString()} \n ${model.taskDate.toString()}  \n ${model.taskTime.toString().trim()}');
                  },
                  child: Container(
                    color: Colors.yellow,
                    child: Card(
                      elevation: 8.0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Checkbox(value: false, onChanged: (value) {}),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${model.taskTitle}',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                textBaseline: TextBaseline.ideographic,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${model.taskDate}',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey[500]),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      '${model.taskTime}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.9,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: IconButton(
                                      onPressed: () {
                                        isDatePassed = false;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateTaskScreen(
                                                      model: model,
                                                    )));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.indigo[400],
                                        size: 25.0,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

        // List of colors for cards


