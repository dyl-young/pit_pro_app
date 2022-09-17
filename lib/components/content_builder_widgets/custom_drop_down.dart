import 'package:flutter/material.dart';

Widget customDropDown(String? selectedItem, List<String> itemList, Function onChanged) {
  return SizedBox(
    width: 300,
    child: DropdownButtonFormField<String>(
      // dropdownColor: Colors.green.shade100,
      value: selectedItem, //_moistureController.text,
      decoration: const InputDecoration(
        labelText: '*Soil Moisture Condition',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
      dropdownColor: Colors.green.shade50,
      items: itemList
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child:
                    Text(item), //style: const TextStyle(color: Colors.green)),
              ))
          .toList(),
      onChanged: onChanged(),

      // (item) => setState(
      //   () {
      //     selectedMoisture = item;
      //   },
      // ),
    ),
  );
}
