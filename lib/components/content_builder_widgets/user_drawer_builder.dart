import 'package:flutter/material.dart';
import 'package:pit_pro_app/hive_components/add_edit_delete_functions.dart';

import '../../../models/user.dart';
import '../../pages/user_info_edit_page.dart';
import '../widgets/info_textbox_widget.dart';

Widget buildUserDrawer(BuildContext context, User user) {
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
            image: const AssetImage('assets/su_logo.png'),
            fit: BoxFit.contain,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                //make image tappable
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => bottomSheet()),
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
Widget bottomSheet() {
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
              pickImage();
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

//TODO: Implement pick image function
Future pickImage() async {}
