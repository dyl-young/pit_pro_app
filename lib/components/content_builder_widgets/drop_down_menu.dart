import 'package:flutter/material.dart';

Widget customDropDownMenu() {
  // BuildContext context;
  List<String> items;
  items = ['a', 'b', 'c'];
  String selectedItem = items.first;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: DropdownButton<String>(
      value: selectedItem,
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: (item) => selectedItem = item??'',
    ),
  );
}
