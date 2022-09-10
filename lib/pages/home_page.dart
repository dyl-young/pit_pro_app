import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../boxes.dart';
import '../models/job.dart';
import '../models/trial_pit.dart';
import '../models/user.dart';
import 'components/job_content_builder.dart';
import 'components/user_drawer_builder.dart';

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
  final User user = User('D Young', 'Stellenbsoch University', 'assests/su_logo.png');

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

      //!Job card view
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
                      borderRadius: BorderRadius.circular(15)),
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

            //*build listenable Box List :
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
                  return buildJobContent(answerList);
                },
              ),
            ),
          ],
        ),
      ),

      //!floating action button: navigates to Job Form page
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add New Test Pit',
          child: const Icon(Icons.add, size: 30),
          onPressed: () {} // => Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const BuildJobContent(
          //       onClickedDone: addJob(),
          //     ),
          //   ),
          // ),
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
  void _runFilter(String enteredKeyword, List<Job> jobs) {
    List<Job> results = [];
    if (enteredKeyword.isEmpty || enteredKeyword == '') {
      results = jobs;
    } else {
      results = jobs
          .where(
            (element) => element.jobNumber
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()),
          )
          .toList();
    }
    setState(() {
      foundList = results;
    });
  }
}

//add new Job
Future addJob(String jobNum, String jobTitle, List<TrialPit> trialPits) async {
  final Job job = Job()
    ..jobNumber = jobNum
    ..jobTitle = jobTitle
    ..trialPitList = trialPits;

  final box = Boxes.getJobs();
  box.add(job);
}

//edit existing Job
void edit(Job job, String jobNum, String jobTitle, List<TrialPit> trialPits) {
  job.jobNumber = jobNum;
  job.jobTitle = jobTitle;
  job.trialPitList = trialPits;
  job.save();
}

//delete existing Job
void deleteJob(Job job) {
  for (var e in job.trialPitList) {
    //TODO: make sure layers of the trial pit are also deleted
    //perhaps call deleteTrialPit() function instead of delete()
    e.delete();
  }
  job.delete();
}
