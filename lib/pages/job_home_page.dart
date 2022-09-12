import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pit_pro_app/pages/trial_pit_page.dart';

import '../components/content_builder_widgets/user_drawer_builder.dart';
import '../hive_components/add_edit_delete_functions.dart';
import '../hive_components/boxes.dart';
import '../components/content_builder_widgets/job_content_builder.dart';
import '../models/job.dart';
import '../models/user.dart';

class JobHomePage extends StatefulWidget {
  const JobHomePage({Key? key}) : super(key: key);

  @override
  State<JobHomePage> createState() => _JobHomePageState();
}

class _JobHomePageState extends State<JobHomePage> {
  //list of all objects in reverse order so latest appears at the top
  //list populated with any matching searches from the filter funtion or if no searches, populated with all objects
  //bool indicator showing if searches are being made
  //controls search bar input

  late List<Job> reversedJobs;
  late List<Job> foundList;
  static bool searching = false;
  final _searchController = TextEditingController();

  //Initialise App User
  final User user =
      User('D Young', 'Stellenbsoch University', 'assests/su_logo.png');

  //initialise states
  @override
  void initState() {
    final testPitslist = Boxes.getJobs().values.toList().cast<Job>();
    reversedJobs = (testPitslist).reversed.toList();
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
    return Scaffold(
      //!appbar
      appBar: AppBar(
        title: const Text('Test Pit Log'),
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
              padding: const EdgeInsets.all(16.0),
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
            SizedBox(
              height: 669.5,
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
                  return buildJobContent(context, answerList);
                },
              ),
            ),
          ],
        ),
      ),

      //!floating action button: navigates to Trial Pit page
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add New Test Pit',
        child: const Icon(Icons.add, size: 30),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TrialPitPage(
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
