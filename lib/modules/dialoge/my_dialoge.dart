import 'package:flutter/material.dart';
import 'package:my_reminder/shared/components/components.dart';

class MyDialoge extends StatefulWidget {
  const MyDialoge({
    required this.days,
    required this.selectedDays,
    required this.onSelectedDaysListChanged,
  });

  final List days;
  final List selectedDays;
  final ValueChanged<List> onSelectedDaysListChanged;

  @override
  State<MyDialoge> createState() => _MyDialogeState();
}

class _MyDialogeState extends State<MyDialoge> {
  List tempSelectedDays = [];
  @override
  void initState() {
    tempSelectedDays = List.of(widget.selectedDays);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: Dialog(
          child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'DAYS',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            defaultButton(
              onPressFunction: () {
                widget.onSelectedDaysListChanged(tempSelectedDays);
                Navigator.pop(context);
              },
              color: const Color(0xFFfab82b),
              text: 'Done',
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.days.length,
                itemBuilder: (BuildContext context, int index) {
                  final dayName = widget.days[index];
                  return CheckboxListTile(
                    title: Text(dayName),
                    value: tempSelectedDays.contains(dayName),
                    onChanged: (bool? value) {
                      if (value != null && value) {
                        if (!tempSelectedDays.contains(dayName)) {
                          setState(() {
                            tempSelectedDays.add(dayName);
                          });
                        }
                      } else {
                        if (tempSelectedDays.contains(dayName)) {
                          setState(
                            () {
                              tempSelectedDays
                                  .removeWhere((day) => day == dayName);
                            },
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ])),
    );
  }
}
