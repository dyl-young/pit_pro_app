import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//! Alert pop up box to confirm Job deletion or page exit
//arguments: build context, list of objects containing object to be deleted,
//object to be deleted, object specific delete function
Widget confirmDelete(BuildContext context, List<HiveObject>? objList,
    HiveObject object, Function deletObject) {
      
  //!Delete Alert box
  return AlertDialog(
    title: Column(
      children: const [
        Icon(Icons.delete_rounded, size: 40),
        Text('Are you sure?', style: TextStyle(fontSize: 16)),
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //*yes button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            objList!.remove(object); //remove object from object list
            deletObject(object); //delete object from Hive box
          },
          child: const Text('yes', style: TextStyle(fontSize: 20)),
        ),
        //*no button
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('no', style: TextStyle(fontSize: 20)),
        ),
      ],
    ),
  );
}

//! Alert pop up box to confirm cancel
Widget confirmCancel(BuildContext context, List<HiveObject>? objList) {

  //! Alert box
  return AlertDialog(
    title: const Text("Are you sure?", style: TextStyle(fontSize: 16)),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //*no button
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('no', style: TextStyle(fontSize: 20)),
        ),
        //*yes button
        TextButton(
          onPressed: () {
            for (var element in objList!) {
              element.delete();
            }
            Navigator.of(context).pop(); //pop alert box
            Navigator.of(context).pop(); //pop to previous page
          },
          child: const Text('yes', style: TextStyle(fontSize: 20)),
        ),
      ],
    ),
  );
}
