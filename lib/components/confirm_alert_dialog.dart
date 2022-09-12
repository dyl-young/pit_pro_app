import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//!Alert pop up box to confirm Job deletion or page exit
Widget confirmDelete(BuildContext context, List<HiveObject>? objList, HiveObject object, Function deletObject) {
  return AlertDialog(
    title: const Text("Are you sure?", style: TextStyle(fontSize: 16)),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('no', style: TextStyle(fontSize: 20)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            objList!.isNotEmpty ? deletObject(objList, object) : deletObject(object);
          },
          child: const Text('yes', style: TextStyle(fontSize: 20)),
        ),
      ],
    ),
  );
}
