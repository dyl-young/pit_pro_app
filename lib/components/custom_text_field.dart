import 'package:flutter/material.dart';

//*rounded Textfield
Widget customTextField(String text, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      maxLines: 1,
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
      validator: (title) =>
          title != null && title.isEmpty ? 'Enter a $text' : null,
    ),
  );
}

Widget customTextField2(String text, TextEditingController controller) {
  return SizedBox(
    height: 200,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: 4,
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
        ),
        // validator: (title) =>
        //     title != null && title.isEmpty ? 'Enter $text' : null,
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
        labelText: '$text',
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
      keyboardType: TextInputType.number,
      // validator: (title) =>
      //     title != null && title.isEmpty ? 'Enter a $text' : null,
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
          title != null && title.isEmpty ? 'Enter a $text' : null,
    ),
  );
}


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

//*smaller Headings
Widget subSectionHeading(String heading) {
  return Text(
    heading,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: Colors.green,
    ),
  );
}
