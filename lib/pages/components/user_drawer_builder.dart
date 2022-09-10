import 'package:flutter/material.dart';

import '../../models/user.dart';

Widget buildUserDrawer(BuildContext context, User user) {

  return ListView(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Material(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          child: Ink.image(
            width: 100,
            height: 150,
            image: const AssetImage('assets/su_logo.png'),
            fit: BoxFit.contain,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: ((builder) => bottomSheet()),
                    );
                  },
                ),
                const Positioned(
                  bottom: 4,
                  right: 4,
                  child: CircleAvatar( backgroundColor: Colors.green, maxRadius: 15, child: Icon(Icons.edit, color: Colors.white, size: 15,)),
                ),
              ],
            ),
          ),
        ),
      ),
      // child: Image.asset(
      //   "assets/su_logo.png",
      //   fit: BoxFit.contain,
      // ),
      const SizedBox(
        height: 10,
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('User: '),
              Text(
                user.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Company: '),
              Text(
                user.institutionName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 110, right: 110),
        child: ElevatedButton(
          //TODO:Implement Alert dialog box to change user info 
          onPressed: () {},
          child: const Icon(Icons.edit, color: Colors.white),
          // color: Colors.red,
        ),
      ),
    ],
  );
}

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
        const Text('Choose Institution Image'),
        Center(
          child: TextButton(
            onPressed: () {
              pcikImage();
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

Future pcikImage() async {

}
