import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pit_pro_app/hive_components/add_edit_delete_functions.dart';

import '../../../models/user.dart';
import '../../pages/user_info_edit_page.dart';
import '../widgets/info_textbox_widget.dart';

Widget buildUserDrawer(
    BuildContext context, User user, Function getImageFromGallery) {
  ImageProvider displayImage;

  // (user.institutionLogo != 'assets/su_logo.png')
  displayImage = FileImage(File(user.institutionLogo));
  // : displayImage = const AssetImage('assets/su_logo.png');

  return ListView(
    children: [
      Padding(
        //*Logo Card
        //!cant acess logo from user class?
        //!cant save user seleccted logo to assets
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
        //white background card
        child: Material(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25)),
          //add image
          child: Ink.image(
            width: 100,
            height: 150,
            image: displayImage,
            fit: BoxFit.contain,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                //make image tappable
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) =>
                          bottomSheet(context, getImageFromGallery)),
                    );
                  },
                ),
                //stack edit icon on image
                const Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                      backgroundColor: Colors.green,
                      maxRadius: 12,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 15,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),

      //*user name box
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: infoTextBox('User:         ', user.userName),
      ),

      //*user company box
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: infoTextBox('Company:', user.institutionName),
      ),

      //*User info edit button
      Padding(
        padding: const EdgeInsets.only(left: 110, right: 110),
        child: ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => UserInfoEditPage(
              user: user,
              onClickedDone: ((name, company) => editUser(user, name, company)),
            ),
          ),
          child: const Icon(Icons.edit, color: Colors.white),
          // color: Colors.red,
        ),
      ),
    ],
  );
}

//pick image bottom sheet with gallery button
Widget bottomSheet(BuildContext context, Function getImageFromGallery) {
  return Container(
    height: 70,
    // width: 100,
    // width: MediaQuery.of(context).size.width
    margin: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    child: Column(
      children: [
        const Text('Choose Company Image'),
        Center(
          child: TextButton(
            onPressed: () {
              getImageFromGallery();
              Navigator.of(context).pop();  //dismiss bottom sheet 
              Navigator.of(context).pop();  //and nav drawer to give image a chance to load
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('Gallery'), Icon(Icons.image_outlined)]),
          ),
        ),
      ],
    ),
  );
}

void showSnackBarAsBottomSheet(BuildContext context, String message) {
  showModalBottomSheet<void>(
    context: context,
    barrierColor: const Color.fromRGBO(0, 0, 0, 0),
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 30), () {
        try {
          Navigator.pop(context);
        } on Exception {}
      });
      return Container(
          color: Colors.grey,
          padding: const EdgeInsets.all(12),
          child: Wrap(children: [Text(message)]));
    },
  );
}
