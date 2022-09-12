import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pit_pro_app/components/custom_text_field.dart';
import 'package:pit_pro_app/hive_components/add_edit_delete_functions.dart';

import '../components/cancelButton.dart';
import '../components/confirm_alert_dialog.dart';
import '../hive_components/boxes.dart';
import '../models/job.dart';
import '../models/trial_pit.dart';

class TrialPitPage extends StatefulWidget {
  const TrialPitPage({Key? key, this.job, required this.onClickedDone})
      : super(key: key);

  //class arguments
  final Job? job;
  final Function(String number, String title, List<TrialPit> trialpits)
      onClickedDone;

  @override
  State<TrialPitPage> createState() => _TrialPitPageState();
}

class _TrialPitPageState extends State<TrialPitPage> {
  //attributes
  final formKey = GlobalKey<FormState>();
  final _jobNumController = TextEditingController();
  final _jobTitleController = TextEditingController();
  late List<TrialPit> madeTrialPits = [];

  //initialise state
  @override
  void initState() {
    super.initState();

    if (widget.job != null) {
      final job = widget.job!;
      madeTrialPits = job.trialPitList;

      _jobNumController.text = job.jobNumber;
      _jobTitleController.text = job.jobTitle;
    }
  }

  //Dispose Controllers
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

        //!Job Widgets:
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                //Job Details:
                //*Heading
                sectionHeading('Job Details'),

                //*job number
                customTextField('Job Number', _jobNumController),

                //*job title
                customTextField('Job Title', _jobTitleController),

                //*Add Trial Pit button
                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Add Trial Pit '),
                          Icon(Icons.calendar_view_day)
                        ],
                      ),
                      //TODO: implement adding trial pit
                      onPressed: () {},
                      // onPressed: () => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         const LayerDialogForm(onClickedDone: addLayer),
                      //   ),
                      // ),

                      // onPressed: () => showDialog(
                      //   context: context,
                      //   builder: (context) => LayerDialogForm(
                      //     onClickedDone: (type, height) =>
                      //         addLayer(madelayers, type, height),
                      //   ),
                      // ),
                    ),
                  ),
                ),

                //*Trial Pits Heading
                sectionHeading('Trial Pits'),

                //*Trial Pit info tile
                SizedBox(
                    height: 400,
                    child: ValueListenableBuilder<Box<TrialPit>>(
                      valueListenable: Boxes.geTrialPits().listenable(),
                      builder: (context, box, _) {
                        // final layers = box.values.toList().cast<Layer>();
                        return trialPitListViewBuilder(context, madeTrialPits);
                      },
                    )
                    //layersListViewBuilder(context, madelayers)
                    ),
              ],
            ),
          ),
        ),

        //!PDF generate Floating action button
        floatingActionButton: FloatingActionButton(
          tooltip: 'Generate PDF',
          onPressed: () {
              //TODO: implement pdf view page
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context){} => const PdfViewPage()));
          },
          child: const Icon(Icons.picture_as_pdf_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        //!bottom nav bar
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
          shape: const CircularNotchedRectangle(), //shape of notch
          notchMargin: 5,
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

  //TODO: extract widget
  //!add/save button
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

//!list view builder
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
              title: Text('Layer: ${trialPits.lastIndexOf(e) + 1}'),
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
