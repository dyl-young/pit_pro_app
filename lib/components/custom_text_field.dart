
import 'package:flutter/material.dart';

Widget customTextField(String text, TextEditingController controller) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          maxLines: 1,
          controller: controller,
          decoration: InputDecoration(
            labelText: '*$text',
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
          ),
          validator: (title) =>
              title != null && title.isEmpty ? 'Enter a $text' : null,
        ),
      );

//*Headings
Widget sectionHeading(String heading) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      heading,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.green,
      ),
    ),
  );
}
