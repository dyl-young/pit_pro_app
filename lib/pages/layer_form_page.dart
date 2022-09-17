import 'package:flutter/material.dart';
import 'package:pit_pro_app/components/custom_text_field.dart';
import 'package:pit_pro_app/components/layer_properties.dart';

import '../components/buttons.dart';
import '../models/layer.dart';

class LayerFormPage extends StatefulWidget {
  const LayerFormPage({Key? key, this.layer, required this.onClickedDone})
      : super(key: key);
  //*class arguments
  final Layer? layer;
  final Function(
      double depth,
      String moisture,
      String colour,
      String consistency,
      String structure,
      List<String> soilTypes,
      String origin,
      // double wt,
      // double pwt,
      double pm,
      String notes) onClickedDone;

  @override
  State<LayerFormPage> createState() => _LayerFormPageState();
}

class _LayerFormPageState extends State<LayerFormPage> {
  //TODO: Note wt and pwt will be set in pdf gen
  //*attributes
  final layerFormKey = GlobalKey<FormState>();
  final _depthController = TextEditingController();
  final _moistureController = TextEditingController();
  final _colourController = TextEditingController();
  final _consistencyController = TextEditingController();
  final _structureController = TextEditingController();
  final _soilTypesController = TextEditingController();
  final _originController = TextEditingController();
  // final _wtController = TextEditingController();
  // final _pwtController = TextEditingController();
  final _pmController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> moisture = SoilMoisture().getSoilMoisture();
  final List<String> colour = SoilColour().getSoilColour();
  // cohesive or granular //TODO: figure out conditional dropdowns
  late List<String> consistency =
      SoilConsistency().getCohesiveConsistency(); //or .getGranularConsistency
  final List<String> structure = SoilStructure().getSoilStructure();
  final List<String> primSoilTypes = SoilTypes().getPrimSoilTypes();
  final List<String> secSoilTypes = SoilTypes().getSecSoilTypes();
  // transported or residual
  final List<String> origin = TransportedSoilOrigin().getTransportedSoil();

  late String selectedItem = moisture.first;

  @override
  void initState() {
    if (widget.layer != null) {
      final layer = widget.layer;
      _depthController.text = layer!.depth.toString();
      _moistureController.text = layer.moisture;
      _colourController.text = layer.colour;
      _consistencyController.text = layer.consistency;
      _structureController.text = layer.structure;
      _soilTypesController.text = layer.soilTypes
          as String; //TODO: figure out how to deal with soil typse
      // _soilType2Controller.text = layer.soilTypes as String ; //TODO: possibly a second contoller for 2 check lists/radio lists
      _originController.text = layer.origin;
      // final _wtController = layer. ;
      // final _pwtController = layer. ;
      _pmController.text = layer.pmDepth.toString();
      _notesController.text = layer.notes!;
    } else {
      _moistureController.text = moisture.first;
      _colourController.text = colour.first;
      _consistencyController.text = consistency.first;
      _structureController.text = structure.first;
      // _soilTypesController =
      _originController.text = origin.first;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //detrmine title
    final isEditing = widget.layer != null;
    final title = isEditing ? 'Edit Layer' : 'Create Layer';

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
              child: cancelButton(context, [], !isEditing),
            ),
          ],
        ),

        //! Layer form widegts
        body: Form(
          key: layerFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionHeading('Layer Depth'),
                customTextField3('Depth (m)', _depthController),
                sectionHeading('Moisture Content'),
                // customDropDownMenu(),
                Center(
                  child: SizedBox(
                    width: 200,
                    child: DropdownButton<String>(
                      value: selectedItem,
                      items: moisture
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                      onChanged: (item) => setState(
                        () {
                          selectedItem = item ?? '';
                        },
                      ),
                    ),
                  ),
                ),
                sectionHeading('Soil Colour'),
                
                sectionHeading('Soil Consistency'),
                sectionHeading('Soil Structure'),
                sectionHeading('Soil Types'),
                sectionHeading('Soil Origin'),
                sectionHeading('Pebble Marker'),
                sectionHeading('Additional Notes'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
