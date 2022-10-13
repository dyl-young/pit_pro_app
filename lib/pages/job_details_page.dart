//packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

//local imports
import '../components/widgets/buttons.dart';
import '../components/content_builder_widgets/trial_pit_content_builder.dart';
import '../components/widgets/custom_text_field.dart';
import '../hive_components/add_edit_delete_functions.dart';
import '../hive_components/boxes.dart';
import '../models/job.dart';
import '../models/trial_pit.dart';
import 'trial_pit_details_page.dart';

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
  final jobFormKey = GlobalKey<FormState>();
  final _jobNumController = TextEditingController();
  final _jobTitleController = TextEditingController();
  late List<TrialPit> madeTrialPits = [];

  //*initialise method
  @override
  void initState() {
    Boxes.geTrialPits();
    if (widget.job != null) {
      final job = widget.job!;

      //! Get relevant objects from the Hive object box using the created date (kill me)
      for (var i = 0; i < Boxes.geTrialPits().values.toList().length; i++) {
        for (var j = 0; j < job.trialPitList.length; j++) {
          Boxes.geTrialPits().values.toList()[i].createdDate ==
                  job.trialPitList[j].createdDate
              ? madeTrialPits.add(Boxes.geTrialPits().values.toList()[i])
              : [];
        }
      }

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
    //* title
    final isEditing = widget.job != null;
    final title = isEditing ? 'Edit Job' : 'Create Job';
    
    return WillPopScope(
      //disable back device button on this page
      onWillPop: () async => false,
      child: Scaffold(
        //avoid pixel overflow due to keyboard
        resizeToAvoidBottomInset: false,
        //! appbar
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.work_rounded),
              Text(' $title'),
            ],
          ),
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
          key: jobFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8), //?difference

              //Job Details:
              //*Heading
              sectionHeading('Job Details'),

              //*job title
              customTextField('*Job Title', _jobTitleController),

              //*job number
              customTextField('*Job Number', _jobNumController),

              const SizedBox(height: 8),

              //*Trial Pits Heading
              sectionHeading('Trial Pits'),

              const SizedBox(height: 8),

              //*Trial Pit info tiles ListView
              Expanded(
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

        //!floating Action Button
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrialPitDetailsPage(
                onClickedDone: (
                  pitNumber,
                  coords,
                  elevation,
                  wt,
                  pm,
                  layersList,
                  contractor,
                  machine,
                  imagePath,
                  notes,
                ) =>
                    addTrialPit(
                  madeTrialPits,
                  pitNumber,
                  coords,
                  elevation,
                  wt,
                  pm,
                  layersList,
                  contractor,
                  machine,
                  imagePath,
                  notes,
                ),
              ),
            ),
          ),
          label: const Text('Trial Pit'),
          icon: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        //!bottom nav bar
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //save button
              buildSaveButton(context, isEditing: isEditing),
              const SizedBox(width: 20)
            ],
          ),
        ),
      ),
    );
  }

  //!create/save button
  Widget buildSaveButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? ' Save ' : ' Create';

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ButtonStyle(elevation: MaterialStateProperty.all(8)),
        child: Row(
          children: [
            const Icon(Icons.save_alt_rounded, size: 20),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ), //con

        onPressed: () async {
          final isValid = jobFormKey.currentState!.validate();

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
