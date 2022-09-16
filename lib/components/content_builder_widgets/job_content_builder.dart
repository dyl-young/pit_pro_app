import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pit_pro_app/pages/job_details_page.dart';

import '../../hive_components/boxes.dart';
import '../../../models/job.dart';
import '../confirm_alert_dialog.dart';
import '../../hive_components/add_edit_delete_functions.dart';

Widget buildJobContent(BuildContext context, List<Job> jobs) {
  final Box box1 = Boxes.getJobs();
  final Box box2 = Boxes.geTrialPits();
  final Box box3 = Boxes.getLayers();
  final currentWidth = MediaQuery.of(context).size.width;

  if (jobs.isEmpty) {
    return const Center(
      child: Text('No Jobs Found', style: TextStyle(fontSize: 20, color: Colors.grey)),
    );
  } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),

        //!Temp widgets for dev purposes
        //-------------------------------------------------------------
        SizedBox(
            height: 40,
            child: Text(
              'Screen width: $currentWidth',
              style: const TextStyle(color: Colors.red),
            )),
        Text("Number of Jobs in box: ${box1.length}",
            style: const TextStyle(color: Colors.red)),
        Text("Number of Trial Pits in box: ${box2.length}",
            style: const TextStyle(color: Colors.red)),
        Text("Number of Layers in box: ${box3.length}",
            style: const TextStyle(color: Colors.red)),
        TextButton(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 2.0, color: Colors.red),
          ),
          onPressed: () {
            box1.clear();
            box2.clear();
            box3.clear();
          },
          child: const Text('Delete All', style: TextStyle(color: Colors.red)),
        ),
        //-------------------------------------------------------------

        //!Grid view display of all Job detail cards
        //returns detail cards built with buildJobCard widget
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: currentWidth < 500 ? 2 : currentWidth < 650 ? 3 : 4,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 1 / 1.3,
            ),
            itemCount: jobs.length,
            itemBuilder: (BuildContext context, int index) {
              final job = jobs[index];
              return buildJobCard(context, job);
            },
          ),
        ),
      ],
    );
  }
}

//!Job detail card
Widget buildJobCard(BuildContext context, Job job) {
  //details
  final date = DateFormat.yMd().format(DateTime.now());
  final title = job.jobTitle;
  final number = job.jobNumber;

  return Card(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    elevation: 10,
    child: Column(
      children: [
        Theme(
          //*Remove divider line of expanded tile
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 20),
            textColor: const Color.fromARGB(255, 9, 138, 13),

            //*Date heading
            title: Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //*Job title heading
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    title,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                //*Job number heading
                Text(
                  'Job no: $number',
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),

            //date
            //default trailing is a down arrow
            // trailing: Text(date),

            //build edit and delete buttons
            children: [
              buildButtons(context, job),
            ],
          ),
        ),
        Expanded(
          child: IconButton(
            constraints: const BoxConstraints(
              minWidth: 400,
              minHeight: 400,
            ),
            //TODO: navigate to PDF on click
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf),
            iconSize: 110,
            color: Colors.deepOrange,
          ),
        ),
      ],
    ),
  );
}

//!buildButtonn widget
Widget buildButtons(BuildContext context, Job job) {
  const color = Color.fromARGB(255, 9, 138, 13);

  return Row(
    children: [
      //*edit button
      Expanded(
        child: TextButton.icon(
          label: const Text('Edit', style: TextStyle(color: color)),
          icon: const Icon(Icons.edit, color: color),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => JobDeatilsPage(
                    job: job,
                    onClickedDone: ((jobNum, jobTitle, trialPits) =>
                        editJob(job, jobNum, jobTitle, trialPits)),
                  )),
            ),
          ),
        ),
      ),

      //*delete button
      Expanded(
        child: TextButton.icon(
          label: const Text('Delete', style: TextStyle(color: color)),
          icon: const Icon(Icons.delete, color: color),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => confirmDelete(context, [], job, deleteJob),
          ),
        ),
      )
    ],
  );
}
