//packages
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:location/location.dart';

//local imports
import '../components/buttons.dart';
import '../components/content_builder_widgets/layers_content_builder.dart';
import '../components/custom_text_field.dart';
import '../components/location_services.dart';
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
    double wt,
    double pwt,
    List<double> coords,
    double elevation,
    List<Layer> layersList,
  ) onClickedDone;

  @override
  State<TrialPitDetailsPage> createState() => _TrialPitDetailsPageState();
}

class _TrialPitDetailsPageState extends State<TrialPitDetailsPage> {
  //*attributes
  final pitFormKey = GlobalKey<FormState>();
  final _pitNumController = TextEditingController();
  final _xCoordController = TextEditingController();
  final _yCoordController = TextEditingController();
  final _elevationController = TextEditingController();
  final _waterTableController = TextEditingController();
  final _perchedWaterTableController = TextEditingController();

  late List<Layer> madeLayers = [];

  var location = Location();

  //*Initialise method
  @override
  void initState() {
    Boxes.geTrialPits();
    Boxes.getLayers();
    if (widget.trialPit != null) {
      final trialPit = widget.trialPit!;
      madeLayers = trialPit.layersList;

      _pitNumController.text = trialPit.pitNumber;

      _waterTableController.text = trialPit.wtDepth.toString();
      _perchedWaterTableController.text = trialPit.pwtDepth.toString();

      _xCoordController.text = trialPit.coordinates[0].toString();
      _yCoordController.text = trialPit.coordinates[1].toString();
      _elevationController.text = trialPit.elevation.toString();
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
    _perchedWaterTableController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //detrmine title
    final isEditing = widget.trialPit != null;
    final title = isEditing ? 'Edit Trial Pit' : 'Create TrialPit';

    return WillPopScope(
      //disable back device button on this page
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //! appbar
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(angle: pi, child: const Icon(Icons.line_style_outlined)),
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

              //Trial Pit Details
              //*trial pit details heading
              sectionHeading('Trial Pit Details'),
              //*Trial Pit Number
              customTextField('*Hole Number', _pitNumController),

              Padding(
                padding: const EdgeInsets.only(
                    left: 6, right: 6, top: 6),
                child: Row(
                  children: [
                    //*Water table
                    Expanded(
                        child: customTextField3(
                            'Water table (m)', _waterTableController)),
                    //*Perched water table
                    Expanded(
                        child: customTextField3(
                            'Perched WT (m)', _perchedWaterTableController)),
                  ],
                ),
              ),
              //*location sub heading adn autofill button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: subSectionHeading('Location details:'),
                  ),
                  //*autofil location details
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextButton(
                        onPressed: () {
                          getLocation(_xCoordController, _yCoordController, _elevationController);
                          final snackBar = SnackBar(
                            backgroundColor: Colors.grey.shade400,
                            // width: 100,
                            content: const Text('Retriving location details...'),
                            duration: const Duration(seconds: 5),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                        },
                        child: const Text('Autofill')),
                  )
                ],
              ),
              //*location text fields
              Padding(
                padding: const EdgeInsets.only(
                    left: 6, right: 6, bottom: 8.0, top: 4),
                child: Row(
                  children: [
                    //*coordinates
                    Expanded(
                        child:
                            customTextField3('Longitude', _xCoordController)),
                    Expanded(
                        child:
                            customTextField3('Latitude', _yCoordController)),
                    //*elevation
                    Expanded(
                        child: customTextField3(
                            'Elevation', _elevationController)),
                  ],
                ),
              ),

              // const SizedBox(height: 8),
              //TODO: Implement select/capture image of trial pits

              //* layers heading
              sectionHeading('Layers'),
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
    final text = isEditing ? 'Save ' : 'Create TrialPit ';

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
          final isValid = pitFormKey.currentState!.validate();

          if (isValid) {
            final num = _pitNumController.text;
            final wt = double.tryParse(_waterTableController.text) ?? 0;
            final pwt = double.tryParse(_perchedWaterTableController.text) ?? 0;
            final xCoord = double.tryParse(_xCoordController.text) ?? 0;
            final yCoord = double.tryParse(_yCoordController.text) ?? 0;
            final elevation = double.tryParse(_elevationController.text) ?? 0;

            widget.onClickedDone(
                num, wt, pwt, [xCoord, yCoord], elevation, madeLayers);

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
}
