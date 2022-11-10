//* lirbraries
import 'dart:io';

//* packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//* local imports
import '../components/content_builder_widgets/user_drawer_builder.dart';
import '../components/widgets/page_transition.dart';
import '../constants/images.dart';
import '../hive_components/add_edit_delete_functions.dart';
import '../hive_components/boxes.dart';
import '../components/content_builder_widgets/job_content_builder.dart';
import '../models/job.dart';
import '../models/user.dart';
import 'job_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //* attributes
  late final User user;
  late List<Job> reversedJobs;
  late List<Job> displayList;
  static bool isSearching = false;
  final _searchController = TextEditingController();

  //* initialise method
  @override
  void initState() {
    //* initialise User
    if (Boxes.getUsers().isEmpty) {
      user = User('', '', Images.logo);
      final box = Boxes.getUsers();
      box.add(user);
    } else {
      user = Boxes.getUsers().values.first;
    }

    //* initialise Job list with existing jobs
    final jobList = Boxes.getJobs().values.toList().cast<Job>();
    reversedJobs = (jobList).reversed.toList();
    displayList = reversedJobs;

    super.initState();
  }

  //* dispose method
  @override
  void dispose() {
    Hive.close(); // close Hive boxes
    super.dispose();
  }

  //* build method
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // unfocus keyboard
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
          isSearching = false;
          displayList = reversedJobs;
          _searchController.clear();
        }
      },

      child: Scaffold(
        resizeToAvoidBottomInset: false, //prevent FAB from moving with keybaord

        //! appbar
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.broken_image_outlined),
              Text(' PIT PRO'),
            ],
          ),
          centerTitle: true,
        ),

        //! User Drawer
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(45))),
          backgroundColor: Colors.green,
          child: buildUserDrawer(context, user, getImageFromGallery),
        ),

        //! widgets
        body: SingleChildScrollView(
          child: Column(
            children: [
              //*Search bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search ',
                    suffixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    _searchController.clear();
                    displayList = reversedJobs;
                    isSearching = false;
                  },
                  onChanged: (value) {
                    isSearching = true;
                    _runFilter(value, reversedJobs);
                  },
                ),
              ),

              //* Job heading :
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.work_rounded),
                  Text(' Jobs',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))
                ],
              ),

              //*Job card list builder
              SizedBox(
                height: MediaQuery.of(context).size.width < 500
                ? MediaQuery.of(context).size.height - 213
                : MediaQuery.of(context).size.height - 205,
                child: ValueListenableBuilder<Box<Job>>(
                  valueListenable: Boxes.getJobs().listenable(),
                  builder: (context, box, _) {
                    final jobs = box.values.toList().cast<Job>();
                    reversedJobs = jobs.reversed.toList();
                    List<Job> answerList;

                    if (!isSearching) {
                      //not searchin: display full list
                      answerList = reversedJobs;
                    } else {
                      //searching: display list of found matches
                      answerList = displayList;
                    }
                    //*builder
                    return buildJobContent(
                        context, user, answerList, isSearching);
                  },
                ),
              ),
            ],
          ),
        ),

        //!floating action button: navigates to Trial Pit page
        floatingActionButton: FloatingActionButton.extended(
            label: const Text('   Job   '),
            icon: const Icon(Icons.add, size: 30),
            onPressed: () => Navigator.of(context).push(
                createRoute(const JobDeatilsPage(onClickedDone: addJob))
                ),
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        //*bottom bar: no function
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5,
          child: Row(
            children: const [SizedBox(height: 34)],
          ),
        ),
      ),
    );
  }

  //! filter Job cards according to title or job number
  void _runFilter(String enteredKeyword, List<Job> jobs) {
    List<Job> results = [];
    if (enteredKeyword.isEmpty || enteredKeyword == '') {
      results = jobs;
    } else {
      results = jobs.where(
        (element) {
          if (element.jobNumber
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              element.jobTitle
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase())) {
            return true;
          } else {
            return false;
          }
        },
      ).toList();
    }
    setState(() {
      displayList = results;
    });
  }

  //! save user image to app directory
  void getImageFromGallery() async {
    XFile? pickedFile;
    final File newFile;
    final Directory dir = await getApplicationDocumentsDirectory();
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (user.institutionLogo != 'assets/app_logo.png') {
        deleteFile(File(user.institutionLogo));
      }
      newFile = await File(pickedFile.path)
          .copy('${dir.path}/companyLogo${extension(pickedFile.path)}');

      setState(() {
        user.institutionLogo = newFile.path;
        user.save();
      });
    }
  }
}
