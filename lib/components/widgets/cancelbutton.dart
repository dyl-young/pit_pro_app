//packages
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//local imports
import 'confirm_alert_dialog.dart';

//! cancel button
Widget cancelButton(BuildContext context, List<HiveObject> objList, bool isNotEditing) {
  if (isNotEditing) {
    return ElevatedButton(
      style:  ButtonStyle(elevation: MaterialStateProperty.all(8)),
      child: Row(
        children: const [
          Text('Cancel ', style: TextStyle(fontSize: 12)),
          Icon(Icons.cancel_outlined, size: 15),
        ],
      ),

      onPressed: () => showDialog(
        context: context,
        builder: (context) => confirmCancel(context, objList),
      ),
    );
  } else {
    return const SizedBox.shrink(); //no cancel option when editing existing objects
  }
}
