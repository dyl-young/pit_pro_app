import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pit_pro_app/components/custom_text_field.dart';
import 'package:pit_pro_app/hive_components/add_edit_delete_functions.dart';
import 'package:pit_pro_app/pages/Trial_pit_details_page.dart';

import '../components/buttons.dart';
import '../components/confirm_alert_dialog.dart';
import '../hive_components/boxes.dart';
import '../models/job.dart';
import '../models/trial_pit.dart';

class JobDeatilsPage extends StatefulWidget {
  const JobDeatilsPage({Key? key, this.job, required this.onClickedDone})
      : super(key: key);

  //*class arguments
  final Job? job;
  final Function(String number, String title, List<TrialPit> trialpits)
      onClickedDone;

  @override
  State<JobDeatilsPage> createState() => _JobDeatilsPageState();
}

class _JobDeatilsPageState extends State<JobDeatilsPage> {
  //*attributes
  final formKey = GlobalKey<FormState>();
  final _jobNumController = TextEditingController();
  final _jobTitleController = TextEditingController();
  late List<TrialPit> madeTrialPits = [];

  //*initialise method
  @override
  void initState() {
    if (widget.job != null) {
      final job = widget.job!;
      madeTrialPits = job.trialPitList;

      _jobNumController.text = job.jobNumber;
      _jobTitleController.text = job.jobTitle;
    }
    super.initState();
  }

  //*dispose Controllers
  @override
  void dispose() {
    _jobNumController.dispose();
    _jobTitleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //detrmine title
    final isEditing = widget.job != null;
    final title = isEditing ? 'Edit Job' : 'Create Job';

    return WillPopScope(
      //disable back device button on this page
      onWillPop: () async => false,
      child: Scaffold(
        //! appbar
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          //*disable automatic back button
          automaticallyImplyLeading: false,

          //*Cancel button
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cancelButton(context, madeTrialPits, !isEditing),
            ),
          ],
        ),

        //! Job widgets:
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8), //?difference

                //Job Details:
                //*Heading
                sectionHeading('Job Details'),

                //*job number
                customTextField('Job Number', _jobNumController),

                //*job title
                customTextField('Job Title', _jobTitleController),

                const SizedBox(height: 8),

                //*Trial Pits Heading
                sectionHeading('Job Activities'),

                const SizedBox(height: 8),

                //*Add Trial Pit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //*Borehole button
                    addOtherButtons('Borehole'),

                    //*Trial Pit button
                    addTrialPittButton(context, madeTrialPits, 'Trial Pit'),

                    //*Auger button
                    addOtherButtons('Auger'),
                  ],
                ),

                const SizedBox(height: 8),

                //*Trial Pit info tiles ListView
                SizedBox(
                  height: 400,
                  child: ValueListenableBuilder<Box<TrialPit>>(
                    valueListenable: Boxes.geTrialPits().listenable(),
                    builder: (context, box, _) {
                      return trialPitListViewBuilder(context, madeTrialPits);
                    },
                  ),
                ),
                // buildTrialPitContent(madeTrialPits),
              ],
            ),
          ),
        ),

        //!PDF generate Floating action button
        floatingActionButton: isEditing
            ? FloatingActionButton(
                tooltip: 'Generate PDF',
                //TODO: implement pdf view page
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context){} => const PdfViewPage()));
                },
                child: const Icon(Icons.picture_as_pdf_rounded),
              )
            : const SizedBox.shrink(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        //!bottom nav bar
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          shape: const CircularNotchedRectangle(), //shape of notch
          notchMargin: isEditing ? 5 : 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //save button
              buildSaveButton(context, isEditing: isEditing),
            ],
          ),
        ),
      ),
    );
  }

  //!create/save button
  Widget buildSaveButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save ' : 'Create Job ';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: 16)),
            const Icon(Icons.save_alt_rounded, size: 20),
          ],
        ), //con

        onPressed: () async {
          final isValid = formKey.currentState!.validate();

          if (isValid) {
            final num = _jobNumController.text;
            final title = _jobTitleController.text;
            // final madelayers = test

            widget.onClickedDone(num, title, madeTrialPits);

            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}


//! Borehole andg aguer buttons(if implemented, split up buttons)
Widget addOtherButtons(String title) {
  return SizedBox(
    width: 117,
    height: 40,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.grey),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add),
          Text(title),
        ],
      ),
      onPressed: () {},
    ),
  );
}

//! Trial Pit Button
Widget addTrialPittButton(
    BuildContext context, List<TrialPit> trialPits, String title) {
  return SizedBox(
    width: 117,
    height: 40,
    child: ElevatedButton(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add),
          Text(title),
        ],
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => TrialPitDetailsPage(
          onClickedDone: (pitNumber, coords, elevation, layersList) =>
              addTrialPit(trialPits, pitNumber, coords, elevation, layersList),
        ),
      ),
    ),
  );
}

//TODOD: URGENT extract following wdiegts
//! list builder
Widget trialPitListViewBuilder(BuildContext context, List<TrialPit> trialPits) {
  return ListView(
    children: [
      ...trialPits.map(
        (e) => Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(255, 219, 219, 219),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.calendar_view_day),
              tilePadding: const EdgeInsets.all(5),
              title: Text('Trial Pit: ${trialPits.lastIndexOf(e) + 1}'),
              // subtitle: Text(e.),
              // subtitle: Text(
              //     '  type: ${e.type} \n  height: ${e.height.toString()} m'),
              children: [
                buildTrialPitButtons(context, trialPits, e),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
//! Expansion tile buttons
Widget buildTrialPitButtons(
    BuildContext context, List<TrialPit> trialPits, TrialPit trialPit) {
  const color = Color.fromARGB(255, 9, 138, 13);

  return Row(
    children: [
      //*edit button
      Expanded(
        child: TextButton.icon(
            label: const Text('Edit', style: TextStyle(color: color)),
            icon: const Icon(Icons.edit, color: color),
            //TODO: implement edit Trial pit
            onPressed: () {}
            // => showDialog(
            //   context: context,
            //   builder: (context) => LayerDialogForm(
            //     layer: layer,
            //     onClickedDone: ((type, height) => editLayer(layer, type, height)),
            //   ),
            // ),
            ),
      ),

      //*delete button
      Expanded(
        child: TextButton.icon(
          label: const Text('Delete', style: TextStyle(color: color)),
          icon: const Icon(Icons.delete, color: color),
          onPressed: () => showDialog(
            context: context,
            builder: (context) =>
                confirmDelete(context, trialPits, trialPit, deleteTrialPit),
          ),
        ),
      )
    ],
  );
}
