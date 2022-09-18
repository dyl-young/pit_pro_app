import 'package:flutter/material.dart';
import 'package:pit_pro_app/components/custom_text_field.dart';
import 'package:pit_pro_app/components/layer_properties.dart';

import '../components/buttons.dart';
import '../components/content_builder_widgets/custom_drop_down.dart';
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

  //*Note wt and pwt will be set in pdf gen
  //*attributes
  final layerFormKey = GlobalKey<FormState>();
  
  //implemented
  final _depthController = TextEditingController(); 
  String? selectedMoisture;
  String? selectedColour;
  String? selectedConsistency;
  String? selectedConsistencyType;
  String? selectedStructure;
  final _notesController = TextEditingController();

  //unimplemented
  final _soilTypesController = TextEditingController();
  final _originController = TextEditingController();
  final _pmController = TextEditingController();

  //*predefined layer properties
  // implemented
  final List<String> moisture = SoilMoisture().getSoilMoisture();
  final List<String> colour = SoilColour().getSoilColour();
  List<String> consistency = [];
  List<String> consistencyType = ['Cohesive', 'Granular'];
  final List<String> structure = SoilStructure().getSoilStructure();

  //unimplemented
  final List<String> primSoilTypes = SoilTypes().getPrimSoilTypes();
  final List<String> secSoilTypes = SoilTypes().getSecSoilTypes();
    // transported or residual
  final List<String> origin = TransportedSoilOrigin().getTransportedSoil();

  @override
  void initState() {
    if (widget.layer != null) {
      final layer = widget.layer;

      _depthController.text = layer!.depth.toString();
      selectedMoisture = layer.moisture;
      selectedColour = layer.colour;
      if (SoilConsistency()
          .getCohesiveConsistency()
          .contains(layer.consistency)) {
        selectedConsistencyType = consistencyType[0];
      } else {
        selectedConsistencyType = consistencyType[1];
      }
      selectedConsistency = layer.consistency;
      selectedStructure = layer.structure;
      _notesController.text = layer.notes!;

      _soilTypesController.text = layer.soilTypes
          as String; //TODO: figure out how to deal with soil typse
      // _soilType2Controller.text = layer.soilTypes as String ; //TODO: possibly a second contoller for 2 check lists/radio lists
      _originController.text = layer.origin;
      // final _wtController = layer. ;
      // final _pwtController = layer. ;
      _pmController.text = layer.pmDepth.toString();
    } else {
      selectedConsistencyType = 'Granular';
      // consistency = SoilConsistency().getGranularConsistency();
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
                //! Depth: numeric textfield
                sectionHeading('Layer Depth'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customTextField4('Depth (m)', _depthController),
                ),
                //! Moisture: drop down
                sectionHeading('Moisture Content'),
                customDropDownMenu(
                    selectedMoisture, moisture, '*Soil Moisture Condition'),

                //! Colour: dropdown
                sectionHeading('Soil Colour'),
                customDropDownMenu(selectedColour, colour, '*Soil Colour'),

                //! Consistency: multilevel dropdown
                sectionHeading('Soil Consistency'),
                Center(
                  child: consistencyDropDowMenu(
                      selectedConsistencyType, consistencyType, consistency),
                ),

                //! Structure: dropdown
                sectionHeading('Soil Structure'),
                customDropDownMenu(
                    selectedStructure, structure, '*Soil Structure'),

                //! Soil Types: check box/radio button group
                sectionHeading('Soil Types'),
                const Placeholder(fallbackHeight: 180),
                //! Origin: drop down -> dropdown or -> textField
                sectionHeading('Soil Origin'),
                const Placeholder(fallbackHeight: 80),
                //! Pebble Marker: numeric textfield
                sectionHeading('Pebble Marker'),
                const Placeholder(fallbackHeight: 80),
                //! Notes: text field
                sectionHeading('Additional Notes'),
                customTextField2('Notes', _notesController),
              ],
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

  //!create/save button
  Widget buildSaveButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save ' : 'Create Layer ';

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
          // final isValid = pitFormKey.currentState!.validate();

          // if (isValid) {
          //   final num = _pitNumController.text;
          //   final wt = double.tryParse(_waterTableController.text) ?? 0;
          //   final pwt = double.tryParse(_perchedWaterTableController.text) ?? 0;
          //   final xCoord = double.tryParse(_xCoordController.text) ?? 0;
          //   final yCoord = double.tryParse(_yCoordController.text) ?? 0;
          //   final elevation = double.tryParse(_elevationController.text) ?? 0;

          //   widget.onClickedDone(
          //       num, wt, pwt, [xCoord, yCoord], elevation, madeLayers);

          Navigator.of(context).pop();
          // }
        },
      ),
    );
  }

  //! general drop-down menu
  Widget customDropDownMenu(
      String? selectedItem, List<String> itemList, String label) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 300,
          child: DropdownButtonFormField<String>(
            // dropdownColor: Colors.green.shade100,
            value: selectedItem, //_moistureController.text,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
            ),
            dropdownColor: Colors.green.shade50,
            items: itemList
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                          item), //style: const TextStyle(color: Colors.green)),
                    ))
                .toList(),
            onChanged: (item) => setState(
              () {
                selectedItem = item;
              },
            ),
          ),
        ),
      ),
    );
  }

//! multilevel drop-down menu
  Widget consistencyDropDowMenu(
      String? selectedConsistencyType, List<String> consisType,  List<String> consis) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              value: selectedConsistencyType,
              dropdownColor: Colors.green.shade50,
              decoration: const InputDecoration(
                // labelText: 'Soil Consistency',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
              items: consisType
                  .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (item) {
                    
                setState(
                  () {
                    if (selectedConsistencyType == 'Cohesive') {
                      consistency = SoilConsistency().getCohesiveConsistency();
                    } else if (selectedConsistencyType == 'Granular') {
                      consistency = SoilConsistency().getGranularConsistency();
                    }
                    selectedConsistency = null;
                    selectedConsistencyType = item!;
                  },
                );
              },
            ),
          ),
        ),
        // const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              value: selectedConsistency,
              dropdownColor: Colors.green.shade50,
              decoration: const InputDecoration(
                labelText: '*Soil Consistency',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
              ),
              items: consistency
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (item) => setState(
                () {
                  selectedConsistency = item;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
