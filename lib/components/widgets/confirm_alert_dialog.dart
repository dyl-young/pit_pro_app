//packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//! confirm delete object
Widget confirmObjectDelete(BuildContext context, List<HiveObject>? objList, HiveObject object, Function deletObject) {
      
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
            objList!.remove(object); //remove object from object list
            deletObject(object); //delete object from Hive box
            Navigator.of(context).pop();
          },
          child: const Text('yes', style: TextStyle(fontSize: 16)),
        ),
        //*no button
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('no', style: TextStyle(fontSize: 16)),
        ),
      ],
    ),
  );
}

//! confirm delete image
Widget confirmImageDelete(BuildContext context, String path, Function deleteFile) {
      
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
            Navigator.of(context).pop();
            deleteFile(File(path)); //Delete image file
          },
          child: const Text('yes', style: TextStyle(fontSize: 16)),
        ),
        //*no button
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('no', style: TextStyle(fontSize: 16)),
        ),
      ],
    ),
  );
}

//! confirm cancel 
Widget confirmCancel(BuildContext context, List<HiveObject>? objList) {

  return AlertDialog(
    title: const Center(child: Text("Are you sure?", style: TextStyle(fontSize: 16))),
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
