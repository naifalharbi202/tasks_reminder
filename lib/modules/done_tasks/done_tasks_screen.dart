import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/layout/cubit/states.dart';
import 'package:my_reminder/models/task_model.dart';
import 'package:my_reminder/modules/update_task/update_task_screen.dart';
import 'package:my_reminder/shared/components/constants.dart';

class DoneTasksScreen extends StatelessWidget {
  DoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetTaskSuccessState) {
          AppCubit.get(context).getUser();
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: doneTasks.isNotEmpty,
          builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) =>
                  buildTaskItem(doneTasks[index], context),
              separatorBuilder: (context, index) => SizedBox(
                    height: 8.0,
                  ),
              itemCount: doneTasks.length),
          fallback: (context) =>
              const Center(child: ((CircularProgressIndicator()))),
        );
      },
    );
  }

  Widget buildTaskItem(TaskModel model, context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // intl.DateFormat.yMMMEd('ar_SA').format(pickedDate))

              InkWell(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title:
                                const Text('هل أنت متأكد من حذف هذه التذكيرة؟'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    return AppCubit.get(context)
                                        .deleteTask(taskId: model.taskId);
                                  },
                                  child: const Text('نعم')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('إلغاء'))
                            ],
                          ));
                },
                child: Container(
                  child: Card(
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
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
                                          fontSize: 13.9, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: IconButton(
                                    onPressed: () {
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
            ],
          ),
        ),
      );
}
