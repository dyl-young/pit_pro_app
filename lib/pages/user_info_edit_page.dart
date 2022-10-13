//packages
import 'package:flutter/material.dart';

//local imports
import '../components/widgets/custom_text_field.dart';
import '../models/user.dart';

class UserInfoEditPage extends StatefulWidget {
  const UserInfoEditPage(
      {Key? key, required this.onClickedDone, required this.user})
      : super(key: key);

  final Function(String name, String company) onClickedDone;
  final User user;

  @override
  State<UserInfoEditPage> createState() => _UserInfoEditPageState();
}

class _UserInfoEditPageState extends State<UserInfoEditPage> {
  //* attributes
  final nameController = TextEditingController();
  final companyController = TextEditingController();

  //* initialise method
  @override
  void initState() {
    nameController.text = widget.user.userName;
    companyController.text = widget.user.institutionName;
    super.initState();
  }
  
  //* dispose method
  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    super.dispose();
  }

  //* build method
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      //* title
      title: const Center(child: Text('Edit User Details')),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      
      //* text fields
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              customTextField('Name', nameController),
              customTextField('Company Name', companyController)
            ],
          ),
        ),
      ),
      
      actions: [
        //* cancel button
        TextButton(
          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus(); //dismiss keybaord
            Navigator.of(context).pop();
          },
        ),

        //* save button
        TextButton(
          child: const Text('Save', style: TextStyle(fontSize: 16)),
          onPressed: () {
            final username = nameController.text;
            final companyName = companyController.text;
            
            FocusManager.instance.primaryFocus?.unfocus();  //dismiss keybaord
            widget.onClickedDone(username, companyName);  
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
