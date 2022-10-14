//packages
import 'package:flutter/material.dart';

//*!rounded Textfield
Widget customTextField(String text, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
    child: TextFormField(
      maxLines: 1,
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
      validator: (title) =>
          title != null && title.isEmpty ? '$text is required' : null,
    ),
  );
}

//! taller notes text field
Widget customTextField2(String text, TextEditingController controller) {
  return SizedBox(
    height: 125,
    child: Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: TextFormField(
        textInputAction: TextInputAction.newline,
        maxLines: 4,
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
        ),
      ),
    ),
  );
}

//! smaller and for digits
Widget customTextField3(String text, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 2, right: 2),
    child: TextFormField(
      maxLines: 1,
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
      keyboardType: TextInputType.number,
    ),
  );
}

//! smaller for digits  && validated
Widget customTextField4(String text, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 2, right: 2),
    child: TextFormField(
      maxLines: 1,
      controller: controller,
      decoration: InputDecoration(
        labelText: '*$text',
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
      keyboardType: TextInputType.number,
      validator: (title) =>
          title != null && title.isEmpty ? '$text is required' : null,
    ),
  );
}

//! smaller for charcaters not validated
Widget customTextField5(String text, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(left: 2, right: 2),
    child: SizedBox(
      width: 200,
      child: TextFormField(
        maxLines: 1,
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
        ),
      ),
    ),
  );
}

//*! rounded Textfield
Widget customTextField6(String text, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
    child: SizedBox(
      width: 300,
      child: TextFormField(
        maxLines: 1,
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
        ),
      ),
    ),
  );
}

//! Headings
Widget sectionHeading(String heading) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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

//! smaller Headings
Widget subSectionHeading(String heading) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
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
