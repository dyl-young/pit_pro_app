import 'dart:io';

//packages
import 'package:flutter/material.dart';

//local imports
import '../../../models/user.dart';
import '../../hive_components/add_edit_delete_functions.dart';
import '../../pages/user_info_edit_page.dart';
import '../widgets/info_textbox_widget.dart';

Widget buildUserDrawer(
    BuildContext context, User user, Function getImageFromGallery) {
  ImageProvider displayImage;

  (user.institutionLogo != 'assets/app_logo.png')
  ? displayImage = FileImage(File(user.institutionLogo))
  : displayImage = const AssetImage('assets/app_logo.png');

  final currentHeight = MediaQuery.of(context).size.height;



  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        height: currentHeight-50,
        child: ListView(
              children: [
                Padding(
                  //*Logo Card
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
                  child: infoTextBox('User:         ', user.userName, const Icon(Icons.person)),
                ),

                //*user company box
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: infoTextBox('Company:', user.institutionName, const Icon(Icons.business_center)),
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
            ),
      ),
      const Padding(
        padding: EdgeInsets.all(4.0),
        child: Text('Created By\nDylan Young'),
      )
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
                children: const [Icon(Icons.image_outlined), Text('Gallery')]),
          ),
        ),
      ],
    ),
  );
}
