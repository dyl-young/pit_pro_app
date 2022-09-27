import 'dart:math';

//packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:location/location.dart';

//local imports
import '../components/widgets/info_textbox_widget.dart';
import '../components/content_builder_widgets/layers_content_builder.dart';
import '../components/widgets/buttons.dart';
import '../components/widgets/custom_text_field.dart';
import '../location_services.dart';
import '../hive_components/boxes.dart';
import '../models/layer.dart';
import '../models/trial_pit.dart';

class TrialPitDetailsPage extends StatefulWidget {
  const TrialPitDetailsPage(
      {Key? key, this.trialPit, required this.onClickedDone})
      : super(key: key);

  //*class arguments
  final TrialPit? trialPit;
  final Function(
      String pitNumber,
      List<double> coords,
      double elevation,
      double wt,
      List<Layer> layersList,
      String contractor,
      String machine,
      String imagePath,
      String notes) onClickedDone;

  @override
  State<TrialPitDetailsPage> createState() => _TrialPitDetailsPageState();
}

class _TrialPitDetailsPageState extends State<TrialPitDetailsPage> {
  //*local attributes
  final pitFormKey = GlobalKey<FormState>();
  final _pitNumController = TextEditingController();
  final _xCoordController = TextEditingController();
  final _yCoordController = TextEditingController();
  final _elevationController = TextEditingController();
  final _waterTableController = TextEditingController();
  final _contractorController = TextEditingController();
  final _machineController = TextEditingController();
  final _notesController = TextEditingController();
  late final String _imagePath = ' ';

  late List<Layer> madeLayers = [];

  var location = Location();

  //*Initialise method
  @override
  void initState() {
    Boxes.geTrialPits();
    Boxes.getLayers();

    if (widget.trialPit != null) {
      final trialPit = widget.trialPit!;

      //! Get relevant objects from the object box using the created date (kill me)
      for (var i = 0; i < Boxes.getLayers().values.toList().length; i++) {
        for (var j = 0; j < trialPit.layersList.length; j++) {
          Boxes.getLayers().values.toList()[i].createdDate ==
                  trialPit.layersList[j].createdDate
              ? madeLayers.add(Boxes.getLayers().values.toList()[i])
              : [];
        }
      }

      _pitNumController.text = trialPit.pitNumber;
      _waterTableController.text = trialPit.wtDepth.toString();

      _xCoordController.text = trialPit.coordinates[0].toString();
      _yCoordController.text = trialPit.coordinates[1].toString();
      _elevationController.text = trialPit.elevation.toString();

      _contractorController.text = trialPit.contractor;
      _machineController.text = trialPit.machine;
      _notesController.text = trialPit.notes;
    }
    super.initState();
  }

  //*Dispose method
  @override
  void dispose() {
    _pitNumController.dispose();
    _xCoordController.dispose();
    _yCoordController.dispose();
    _elevationController.dispose();
    _waterTableController.dispose();
    _contractorController.dispose();
    _machineController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //detrmine title
    final isEditing = widget.trialPit != null;
    final title = isEditing ? 'Edit Trial Pit' : 'Create Trial Pit';

    return WillPopScope(
      //disable back device button on this page
      onWillPop: () async => false,

      child: Scaffold(
        //prevent keybaord overflow
        resizeToAvoidBottomInset: false,
        //! appbar
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                  angle: pi, child: const Icon(Icons.line_style_outlined)),
              Text(' $title'),
            ],
          ),
          centerTitle: true,
          //disable leading back button
          automaticallyImplyLeading: false,

          //*Cancel button
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cancelButton(context, madeLayers, !isEditing),
            ),
          ],
        ),

        //! Trial Pit widgets:
        body: Form(
          key: pitFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* trial pit details heading
              sectionHeading('Trial Pit Details'),

              //* trial Pit Number
              customTextField('*Hole Number', _pitNumController),

              const SizedBox(height: 16),

              Padding(
                padding:
                    const EdgeInsets.only(left: 6, right: 6, bottom: 0),
                child: Row(
                  children: [
                    //* water table
                    Expanded(
                        child: customTextField3(
                            'Water table (m) ', _waterTableController)),
                    //* contractor
                    Expanded(
                        child: customTextField5(
                            'Contractor', _contractorController)),
                    //* machine
                    Expanded(
                        child:
                            customTextField5('Machinery', _machineController)),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //* location details heading
                  subSectionHeading('Location details:'),

                  //* autofil location details
                  autoFillButton(),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6, top: 8),
                child: Row(
                  children: [
                    //* x coordinate
                    Expanded(
                        child:
                            customTextField3('Longitude', _xCoordController)),
                    //* y coordinate
                    Expanded(
                        child: customTextField3('Latitude', _yCoordController)),
                    //* elevation
                    Expanded(
                        child: customTextField3(
                            'Elevation (m)', _elevationController)),
                  ],
                ),
              ),

              //* Trial Pit image
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    subSectionHeading('Add image:'),
                    imageButton(),
                  ],
                ),
              ),
              infoTextBox('', _imagePath != ' ' ? _imagePath : ''),

              //* notes section
              subSectionHeading('Notes:'),

              customTextField2('Notes', _notesController),

              // const SizedBox(height: 8),
              //TODO: Implement select/capture image of trial pits

              //* layers heading
              subSectionHeading('Layers:'),

              //* add layer button
              Center(child: addLayerPittButton(context, madeLayers, 'Layer')),

              const SizedBox(height: 8),

              Expanded(
                child: ValueListenableBuilder<Box<Layer>>(
                  valueListenable: Boxes.getLayers().listenable(),
                  builder: (context, box, _) {
                    return layerListViewBuilder(context, madeLayers);
                  },
                ),
              ),
            ],
          ),
        ),

        //!bottom nav bar
        bottomNavigationBar: BottomAppBar(
          color: Colors.green,
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
    final text = isEditing ? 'Save ' : 'Create TrialPit ';

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontSize: 16)),
            const Icon(Icons.save_alt_rounded, size: 20),
          ],
        ), //con

        onPressed: () async {
          final isValid = pitFormKey.currentState!.validate();

          if (isValid) {
            final num = _pitNumController.text;
            final wt = double.tryParse(_waterTableController.text) ?? 0;
            final xCoord = double.tryParse(_xCoordController.text) ?? 0;
            final yCoord = double.tryParse(_yCoordController.text) ?? 0;
            final elevation = double.tryParse(_elevationController.text) ?? 0;
            final contractor = _contractorController.text;
            final machine = _machineController.text;
            final notes = _notesController.text;
            final imagePath = _imagePath; //TODO: checkimage path

            widget.onClickedDone(
              num,
              [xCoord, yCoord],
              elevation,
              wt,
              madeLayers,
              contractor,
              machine,
              imagePath,
              notes,
            );

            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  double roundDouble(double value) {
    num mod = pow(10.0, 2);
    return ((value * mod).round().toDouble() / mod);
  }

  //! Retreive location data
  void getLocation(TextEditingController long, TextEditingController lat,
      TextEditingController elevation) async {
    final service = LocationServices();
    final locationData = await service.getLocation();

    if (locationData != null) {
      long.text = locationData.longitude!.toStringAsFixed(4);
      lat.text = locationData.latitude!.toStringAsFixed(4);
      elevation.text = locationData.altitude!.toStringAsFixed(2);
    }
  }

  Widget autoFillButton() {
    return SizedBox(
      height: 28,
      child: TextButton(
          onPressed: () {
            getLocation(
                _xCoordController, _yCoordController, _elevationController);
            final snackBar = SnackBar(
              backgroundColor: Colors.grey.shade400,
              // width: 100,
              content: const Text('Retrieving location details...'),
              duration: const Duration(seconds: 5),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: Row(children: const [
            Icon(Icons.autorenew_rounded, size: 18),
            Text('Autofill', style: TextStyle(fontSize: 14))
          ])),
    );
  }

  Widget imageButton() {
    return SizedBox(
      height: 28,
      child: TextButton(
          onPressed: () {},
          child: Row(children: const [
            Icon(Icons.image, size: 18),
            Text('Select Image', style: TextStyle(fontSize: 14))
          ])),
    );
  }
}
