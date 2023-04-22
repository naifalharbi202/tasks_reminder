import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/layout/cubit/states.dart';
import 'package:my_reminder/modules/add_task/add_task_screen.dart';
import 'package:my_reminder/modules/login/login_screen.dart';
import 'package:my_reminder/shared/components/components.dart';
import 'package:my_reminder/shared/components/constants.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 5.0,
            backgroundColor: Colors.blue[400],
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                child: IconButton(
                  onPressed: () {
                    isCategorySelected = false;
                    navigatTo(context, AddTaskScreen());
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
              ),
            ),
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (value) {
                cubit.changeBottomNavIndex(value);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.task_alt_outlined), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
              ]),
          body: cubit.screens[cubit.currentIndex],
        );
      },
    );
  }
}
