//packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

//local imports
import '../components/widgets/buttons.dart';
import '../components/content_builder_widgets/trial_pit_content_builder.dart';
import '../components/widgets/custom_text_field.dart';
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
    final currentWidth = MediaQuery.of(context).size.width;

    if (currentWidth < 650) {
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
    } else {
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
          body: SingleChildScrollView(
            child: SizedBox(
              height: 500,
              child: Form(
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
            ),
          ),

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
