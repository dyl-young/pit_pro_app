import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pit_pro_app/constants/images.dart';
import 'package:pit_pro_app/pages/job_details_page.dart';

import '../components/content_builder_widgets/user_drawer_builder.dart';
import '../hive_components/add_edit_delete_functions.dart';
import '../hive_components/boxes.dart';
import '../components/content_builder_widgets/job_content_builder.dart';
import '../models/job.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //list of all objects in reverse order so latest appears at the top
  //list populated with any matching searches from the filter funtion or if no searches, populated with all objects
  //bool indicator showing if searches are being made
  //controls search bar input

  late List<Job> reversedJobs;
  late List<Job> foundList;
  static bool searching = false;
  final _searchController = TextEditingController();

  //Initialise App User
  late final User user;

  //initialise states
  @override
  void initState() {
    if (Boxes.getUsers().isEmpty) {
      user = User('', '', Images.logo);
      final box = Boxes.getUsers();
      box.add(user);
    } else {
      user = Boxes.getUsers().values.first;
    }

    final jobList = Boxes.getJobs().values.toList().cast<Job>();
    reversedJobs = (jobList).reversed.toList();
    foundList = reversedJobs;
    super.initState();
  }

  //Hive dispose
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: block below stopped the keybaord from popping up
      //when the custon drawer is opended
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        // FocusManager.instance.primaryFocus.unfocus();
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        //!appbar
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

        //!User Drawer
        drawer: Drawer(
          backgroundColor: Colors.green,
          child: buildUserDrawer(context, user),
        ),

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
                  },
                  onChanged: (value) {
                    searching = true;
                    _runFilter(value, reversedJobs);
                  },
                ),
              ),

              //!Job card view
              //*listenable Box List :
              //returns a list of detail cards built in test_pit_content builder
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.work_rounded),
                      Text(' Created Jobs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                    ]),
              ),
              SizedBox(
                // height: 669.5,
                height: MediaQuery.of(context).size.height - 220,
                child: ValueListenableBuilder<Box<Job>>(
                  valueListenable: Boxes.getJobs().listenable(),
                  builder: (context, box, _) {
                    final jobs = box.values.toList().cast<Job>();
                    reversedJobs = jobs.reversed.toList();
                    List<Job> answerList;

                    if (!searching) {
                      //not searching -> display full list
                      answerList = reversedJobs;
                    } else {
                      //searching -> display list of found matches, end
                      answerList = foundList;
                      // searching = false;
                      foundList = reversedJobs;
                    }
                    //*builder
                    return buildJobContent(context, user, answerList);
                  },
                ),
              ),
            ],
          ),
        ),

        //!floating action button: navigates to Trial Pit page
        floatingActionButton: FloatingActionButton(
          tooltip: 'Create a new Job',
          child: const Icon(Icons.add, size: 30),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const JobDeatilsPage(
                onClickedDone: addJob,
              ),
            ),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        //*bottom bar: no function
        bottomNavigationBar: BottomAppBar(
          //bottom navigation bar on scaffold
          color: Colors.green,
          shape: const CircularNotchedRectangle(), //shape of notch
          notchMargin: 5,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [SizedBox(height: 34)],
          ),
        ),
      ),
    );
  }

  //Searches through list of objects and adds an matches to Found List
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
      foundList = results;
    });
  }
}
