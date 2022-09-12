// ignore: file_names
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

Widget cancelButton(
    BuildContext context, List<HiveObject> objList, bool confirmed) {
  if (confirmed) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(),
        child: Row(
          children: const [
            Text('Cancel '),
            Icon(Icons.cancel_outlined, size: 20),
          ],
        ), //const ,
        onPressed: () {
          for (var element in objList) {
            element.delete();
          }
          Navigator.of(context).pop();
        });
  } else {
    return const SizedBox.shrink();
  }
}