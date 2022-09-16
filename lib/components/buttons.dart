import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pit_pro_app/components/confirm_alert_dialog.dart';

Widget cancelButton(
    BuildContext context, List<HiveObject> objList, bool isNotEditing) {
  if (isNotEditing) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(),
      child: Row(
        children: const [
          Text('Cancel '),
          Icon(Icons.cancel_outlined, size: 20),
        ],
      ), //const ,

      onPressed: () => showDialog(
        context: context, 
        builder: (context) => confirmCancel(context, objList),
        ),
      // onPressed: () {
      //   print('testing 1');
      //   confirmCancel(context, objList);
      // },
    );
  } else {
    //no cancel option when editing created jobs
    return const SizedBox.shrink();
  }
}
