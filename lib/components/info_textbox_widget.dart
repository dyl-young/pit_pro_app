import'package:flutter/material.dart';


//Build info text boxes
Widget infoTextBox(String title, String info) {
  return Container(
    height: 40,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(25),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(title),
        SizedBox(
          // height: ,
          width: 185,
          child: Text(
            info,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}