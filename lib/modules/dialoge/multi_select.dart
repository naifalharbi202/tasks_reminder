import 'package:flutter/material.dart';
import 'package:my_reminder/layout/cubit/cubit.dart';

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
        print('itemValue added is $itemValue');
      } else {
        AppCubit.get(context).selectedItems.remove(itemValue);
        print('itemValue removed is $itemValue');
      }
    });
  }

// This method is called when cancel button is clicked
  void cancelRepeate() {
    Navigator.pop(context);
  }

  // This method is called when submit button is clicked
  void submitRepeate() {
    print(AppCubit.get(context).selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SingleChildScrollView(
            child: ListBody(
      children: widget.items
          .map((item) => CheckboxListTile(
              value: AppCubit.get(context).selectedItems.contains(item),
              title: Text(item),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) => itemChange(item, isChecked!)))
          .toList(),
    )));
  }
}
