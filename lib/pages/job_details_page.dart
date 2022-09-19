//packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

//local imports
import '../components/buttons.dart';
import '../components/content_builder_widgets/trial_pit_content_builder.dart';
import '../components/custom_text_field.dart';
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

      //! Get relevant objects from the object box using the created date (kill me) 
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
    //detrmine title
    final isEditing = widget.job != null;
    final title = isEditing ? 'Edit Job' : 'Create Job';

    return WillPopScope(
      //disable back device button on this page
      onWillPop: () async => false,
      child: Scaffold(
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
          child: SingleChildScrollView(
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
                sectionHeading('Job Activities'),

                const SizedBox(height: 8),

                //*Add Trial Pit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //*Borehole button
                    addBoreholeButtons('Borehole'),

                    //*Trial Pit button
                    addTrialPittButton(context, madeTrialPits, 'Trial Pit'),

                    //*Auger button
                    addAugerButtons('Auger'),
                  ],
                ),

                const SizedBox(height: 8),

                //*Trial Pit info tiles ListView
                SizedBox(
                  //TODO: figure out how to make the size dynamic based on screen size
                  height: 418,
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
