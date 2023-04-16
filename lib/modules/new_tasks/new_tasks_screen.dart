import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/layout/cubit/states.dart';
import 'package:my_reminder/main_loading.dart';
import 'package:my_reminder/models/task_model.dart';
import 'package:my_reminder/modules/update_task/update_task_screen.dart';
import 'package:my_reminder/shared/components/components.dart';
import 'package:my_reminder/shared/components/constants.dart';

class NewTasksScreen extends StatelessWidget {
  NewTasksScreen({super.key});

  var categoryController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (newCategory == null) {
      defaultCategories = defaultCategories;
    } else {
      defaultCategories = List<String>.from(newCategory as List);
    }
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // if (state is DeletePostSuccessState) {
        //   Navigator.pop(context);
        // }
        if (state is GetUserSuccessState) {
          AppCubit.get(context).getTask();
          AppCubit.get(context).getCategories();
        }
      },
      builder: (context, state) {
        if (state is GetTaskLoadingState ||
            state is GetAllCategoriesLoadingState) return MainLoadingScreen();
        AppCubit cubit = AppCubit.get(context);
        return RefreshIndicator(
          onRefresh: () => cubit.getTask(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.small(
                          onPressed: () {
                            AppCubit.get(context).getCategories();
                            showDialog(
                                context: context,
                                builder: (context) => Form(
                                      key: formKey,
                                      child: AlertDialog(
                                        title: const Text('إضافة تصنيف جديد'),
                                        content: defaultTextFormField(
                                            controller: categoryController,
                                            type: TextInputType.text,
                                            label: 'أسم التصنيف',
                                            validate: (value) {
                                              if (value!.isEmpty ||
                                                  value.trim().isEmpty) {
                                                return '*';
                                              }
                                              if (value.length > 30) {
                                                return 'لقد تجاوزت عدد الأحرف المسموح به-30-';
                                              }
                                              if (categoriesList!
                                                  .contains(value.trim())) {
                                                return 'أسم التصنيف موجود مسبقًا';
                                              }
                                              return null;
                                            }),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  cubit.addNewCategory(
                                                      categoryName:
                                                          categoryController
                                                              .text
                                                              .trim());
                                                  categoryController.clear();
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text('نعم')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('إلغاء'))
                                        ],
                                      ),
                                    ));
                          },
                          child: const Icon(Icons.sticky_note_2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 8.0, start: 8.0, end: 8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    isCategoryClicked = false;
                                    AppCubit.get(context).getTask();
                                  },
                                  child: const Text(
                                    'جميع التذكيرات',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              const SizedBox(
                                width: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 8.0, start: 8.0, end: 8.0),
                        child: Container(
                          height: 50,
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  buildListItem(categoriesList, index, context),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                              itemCount: categoriesList!.length),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                if (isCategoryClicked == false)
                  ConditionalBuilder(
                    condition: tasks.isNotEmpty,
                    builder: (context) => ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => buildTaskItem(
                              tasks[index],
                              context,
                            ),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 8.0,
                            ),
                        itemCount: tasks.length),
                    fallback: (context) =>
                        const Center(child: ((LinearProgressIndicator()))),
                  ),
                if (isCategoryClicked == true)
                  ConditionalBuilder(
                    condition: selectedTasks.isNotEmpty,
                    builder: (context) => ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => buildTaskItem(
                              selectedTasks[index],
                              context,
                            ),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 8.0,
                            ),
                        itemCount: selectedTasks.length),
                    fallback: (context) =>
                        const Center(child: ((LinearProgressIndicator()))),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildListItem(List<dynamic>? model, index, context) => Container(
        decoration: BoxDecoration(
            color: Colors.blue[300],
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Row(
          children: [
            TextButton(
                onPressed: () {
                  isCategoryClicked = true;
                  AppCubit.get(context).getTask(type: model[index]);
                },
                child: Text(
                  model![index],
                  style: const TextStyle(color: Colors.white),
                )),
            const SizedBox(
              width: 40,
            ),
            IconButton(
                onPressed: () {
                  // toastMessage(message: model[index]);
                  AppCubit.get(context).changeDeltedItemToDefault(
                    model[index],
                  );
                  AppCubit.get(context).deleteSelectedCategory(index: index);
                },
                icon: const Icon(Icons.cancel))
          ],
        ),
      );
}
