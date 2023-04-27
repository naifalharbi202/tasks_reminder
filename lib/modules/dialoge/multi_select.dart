import 'package:flutter/material.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';
import 'package:my_reminder/shared/components/constants.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items; // when we call this class we will pass a list
  const MultiSelect({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  //This method is triggered when checkbox is checked or unchecked
  void itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        AppCubit.get(context).selectedItems.add(itemValue);
        // print('itemValue added is $itemValue');
      } else {
        AppCubit.get(context).selectedItems.remove(itemValue);
        // print('itemValue removed is $itemValue');
      }
    });
  }

// This method is called when cancel button is clicked
  void cancelRepeate() {
    Navigator.pop(context);
  }

  // This method is called when submit button is clicked
  void submitRepeate() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AlertDialog(
          title: Text('تكرار'),
          content: SingleChildScrollView(
              child: ListBody(
            children: widget.items
                .map((item) => CheckboxListTile(
                    value: AppCubit.get(context).selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.platform,
                    onChanged: (isChecked) => itemChange(item, isChecked!)))
                .toList(),
          )),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      dayNumbers = [];
                      isRepeated = true;
                      for (int i = 0;
                          i < AppCubit.get(context).selectedItems.length;
                          i++) {
                        if (AppCubit.get(context).selectedItems[i] ==
                            'كل سبت') {
                          dayNumbers.add(6);
                        } else if (AppCubit.get(context).selectedItems[i] ==
                            'كل أحد') {
                          dayNumbers.add(7);
                        } else if (AppCubit.get(context).selectedItems[i] ==
                            'كل اثنين') {
                          dayNumbers.add(1);
                        } else if (AppCubit.get(context).selectedItems[i] ==
                            'كل ثلاثاء') {
                          dayNumbers.add(2);
                        } else if (AppCubit.get(context).selectedItems[i] ==
                            'كل اربعاء') {
                          dayNumbers.add(3);
                        } else if (AppCubit.get(context).selectedItems[i] ==
                            'كل خميس') {
                          dayNumbers.add(4);
                        } else {
                          dayNumbers.add(5);
                        }
                      }
                      print('dayNumbers ============= $dayNumbers');
                    },
                    child: const Text('تأكيد')),
                TextButton(
                    onPressed: () {
                      cancelRepeate();
                    },
                    child: const Text('إلغاء')),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
