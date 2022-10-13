//* packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//* local imports
import '../components/widgets/cancelbutton.dart';
import '../components/widgets/custom_text_field.dart';
import '../constants/layer_properties.dart';
import '../models/layer.dart';

class LayerFormPage extends StatefulWidget {
  const LayerFormPage({Key? key, this.layer, required this.onClickedDone}): super(key: key);
  
  //*class arguments
  final Layer? layer;
  final Function(
      double depth,
      String moisture,
      String colour,
      String otherColour,
      String colourPattern,
      String consistency,
      String structure,
      List<String> soilTypes,
      String origin,
      String originType,
      double smpl,
      String notes) onClickedDone;

  @override
  State<LayerFormPage> createState() => _LayerFormPageState();
}

class _LayerFormPageState extends State<LayerFormPage> {
  final layerFormKey = GlobalKey<FormState>();

  //*attributes
  //depth
  final _depthController = TextEditingController();
  //moisture
  String? selectedMoisture;
  //colour
  String? selectedColour;
  final _otherColourController = TextEditingController();
  String? selectedColourPattern;
  //consistency
  String? selectedConsistency;
  String? selectedConsistencyType;
  //structure
  String? selectedStructure;
  //notes
  final _notesController = TextEditingController();
  //soil types
  List<String> selectedSoilTypes = [];
  final _otherSoilTypeController = TextEditingController();
  bool visibleOtherST = false;
  //origin
  String? selectedOriginType;
  String? selecetedTransport;
  final _residualController = TextEditingController();
  bool visibleTransported = true;
  bool mustIgnore = true;
  //smpl
  final _smplController = TextEditingController();
  bool visibleSMPL = false;

  //* predefined layer properties
  //moisture
  final List<String> moisture = SoilMoisture().getSoilMoisture();
  //colour
  final List<String> colour = SoilColour().getSoilColour();
  final List<String> colourPattern = SoilColour().getSoilColourPattern();
  final Map<String, Color> colourValues = SoilColour().colourValues;
  //consistency
  final List<String> cohesiveConsistency = SoilConsistency().getCohesiveConsistency();
  final List<String> granularConsistency = SoilConsistency().getGranularConsistency();
  List<String> consistencyType = ['Cohesive', 'Granular'];
  List<String> consistency = [];
  //structure
  final List<String> structure = SoilStructure().getSoilStructure();
  //soil types
  final Map<String, bool> primTypeMap = SoilTypes().primTypes;
  final Map<String, bool> secTypeMap = SoilTypes().secTypes;
  final List<String> primSoilTypes = SoilTypes().getPrimSoilTypes();
  final List<String> secSoilTypes = SoilTypes().getSecSoilTypes();
  //origin
  final List<String> originType = ['Transported Soil', 'Residual Soil'];
  final List<String> transpotOrigin = TransportedSoilOrigin().getTransportedSoil();

  //* initialise method
  @override
  void initState() {
    if (widget.layer != null) {

      //* initialise layer
      final layer = widget.layer;

      //* initialise attributes/controllers
      //depth
      _depthController.text = layer!.depth.toString();
      //Moisture
      selectedMoisture = layer.moisture;
      //colour
      selectedColour = layer.colour;
      _otherColourController.text = layer.otherColour!;
      if (layer.colourPattern != null &&
          layer.colourPattern != ' ' &&
          layer.colourPattern != '') {
        selectedColourPattern = layer.colourPattern;
      }
      //consistency
      if (cohesiveConsistency.contains(layer.consistency)) {
        selectedConsistencyType = consistencyType[0];
        consistency = cohesiveConsistency;
      } else {
        selectedConsistencyType = consistencyType[1];
        consistency = granularConsistency;
      }
      selectedConsistency = layer.consistency;
      //structure
      selectedStructure = layer.structure;
      //notes
      _notesController.text = layer.notes!;
      //soil types
      selectedSoilTypes = layer.soilTypes;
      primTypeMap.forEach((key, value) {
        if (selectedSoilTypes.contains(key)) {
          primTypeMap[key] = true;
        }
      });
      secTypeMap.forEach((key, value) {
        if (selectedSoilTypes.contains(key)) {
          secTypeMap[key] = true;
        }
      });
      for (var e in selectedSoilTypes) {
        if (!secTypeMap.keys.contains(e) && !primTypeMap.keys.contains(e)) {
          visibleOtherST = true;
          _otherSoilTypeController.text += e;
        }
      }
      //origin
      if (transpotOrigin.contains(layer.origin)) {
        selectedOriginType = originType[0];
        selecetedTransport = layer.origin;
        visibleTransported = true;
      } else {
        selectedOriginType = originType[1];
        _residualController.text = layer.origin;
        visibleTransported = false;
      }
      mustIgnore = false;
      //samples
      if (layer.smplDepth != 0) {
        visibleSMPL = true;
        _smplController.text = layer.smplDepth.toString();
      } else {
        _smplController.text = '0.0';
      }
    }

    super.initState();
  }

  //* dispose method
  @override
  void dispose() {
    _depthController.dispose();
    _otherColourController.dispose();
    _otherSoilTypeController.dispose();
    _residualController.dispose();
    _notesController.dispose();
    _smplController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //* title
    final isEditing = widget.layer != null;
    final title = isEditing ? 'Edit Layer' : 'Create Layer';

    return WillPopScope(
      onWillPop: () async => false,
      
      child: Scaffold(
      
        //! appbar
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.layers_rounded),
              Text(' $title'),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,

          //* cancel button
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
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //* moisture: drop down
                  sectionHeading('Moisture Content'),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          value: selectedMoisture,
                          dropdownColor: Colors.green.shade50,
                          decoration: const InputDecoration(
                            labelText: '*Soil Moisture Condition',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          items: moisture.map(
                            (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                            ),
                          ).toList(),
                          onChanged: (item) => setState(
                            () => selectedMoisture = item,
                          ),
                          validator: (title) {
                            if (title == null) {
                              return '*Soil Moisture Condition is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  //* colour: dropdown
                  sectionHeading('Colour'),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          value: selectedColour,
                          dropdownColor: Colors.green.shade50,
                          decoration: const InputDecoration(
                            labelText: '*Soil Colour',
                            border: OutlineInputBorder(
                              borderRadius:BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          items: colour.map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(item),
                                  SizedBox(
                                    height: 30,
                                    width: 50,
                                    child: Container(color: colourValues[item]),
                                  ),
                                ],
                              ),
                            )
                          ).toList(),
                          onChanged: (item) => setState(
                            () {
                              selectedColour = item;
                            },
                          ),
                          validator: (title) {
                            if (title == null) {
                              return '*Soil Colour is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  //* other Colour: Textbox
                  Center(child: customTextField6('Other Soil Colour', _otherColourController)),

                  //* colour Pattern: dropdown
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          value: selectedColourPattern,
                          decoration: const InputDecoration(
                            labelText: 'Colour Pattern',
                            border: OutlineInputBorder(
                              borderRadius:BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          dropdownColor: Colors.green.shade50,
                          items: colourPattern.map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ),
                          ).toList(),
                          onChanged: (item) => setState(
                            () {
                              selectedColourPattern = item;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  //* consistency: dropdown: dropdown
                  sectionHeading('Consistency'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        
                        // drop down 1
                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<String>(
                            dropdownColor: Colors.green.shade50,
                            decoration: const InputDecoration(
                              labelText: 'Select',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                            value: selectedConsistencyType,
                            items: consistencyType.map((item) => DropdownMenuItem<String>(
                                value: item, child: Text(item),
                              ),
                            ).toList(),
                            onChanged: (item) => setState(() {
                                switch (item) {
                                  case 'Cohesive': consistency = cohesiveConsistency;
                                    break;
                                  case 'Granular': consistency = granularConsistency;
                                    break;
                                  default:
                                }
                                selectedConsistencyType = item;
                                selectedConsistency = null;
                              },
                            ),
                          ),
                        ),

                        // drop down 2
                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<String>(
                            value: selectedConsistency,
                            dropdownColor: Colors.green.shade50,
                            decoration: const InputDecoration(
                              labelText: '*Soil Consistency',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                            items: consistency.map((item) => DropdownMenuItem(
                                value: item, child: Text(item),
                              ),
                            ).toList(),
                            onChanged: (item) => setState(() {
                              selectedConsistency = item;
                            }),
                            validator: (title) {
                              if (title == null) {
                                return '*Consistency is required';
                              }
                              return null;
                            },
                          ),
                        ),

                      ],
                    ),
                  ),

                  //* structure: dropdown
                  sectionHeading('Structure'),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                            // dropdownColor: Colors.green.shade100,
                            value:
                                selectedStructure, //_moistureController.text,
                            decoration: const InputDecoration(
                              labelText: '*Soil Structure',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                            dropdownColor: Colors.green.shade50,
                            items: structure
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                          item), //style: const TextStyle(color: Colors.green)),
                                    ))
                                .toList(),
                            onChanged: (item) => setState(
                                  () {
                                    selectedStructure = item;
                                  },
                                ),
                            validator: (title) {
                              if (title == null) {
                                return '*Soil Structure is required';
                              }
                              return null;
                            }),
                      ),
                    ),
                  ),

                  //* soil Types: check box
                  sectionHeading('Soil Types'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      checkBoxGroup(primSoilTypes, primTypeMap),
                      checkBoxGroup(secSoilTypes, secTypeMap),
                    ],
                  ),
                  //*other soil type: check box: text field
                  Row(
                    children: [
                      // checkbox 
                      Padding(
                        padding: const EdgeInsets.only(left: 26.25),
                        child: SizedBox(
                          width: 165,
                          child: CheckboxListTile(
                            title: const Text('Other'),
                            value: visibleOtherST,
                            onChanged: ((val) {
                                setState(
                                  () {
                                    visibleOtherST = val!;
                                  },
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                      // text field
                      Visibility(
                        visible: visibleOtherST,
                        child: SizedBox(
                          width: 200,
                          child: TextFormField(
                            maxLines: 1,
                            controller: _otherSoilTypeController,
                            decoration: const InputDecoration(
                              labelText: 'Other type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //* origin: dropdown: dropdown/textField
                  sectionHeading('Origin'),
                  // dropdown 1
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 300,
                        child: DropdownButtonFormField<String>(
                          value: selectedOriginType,
                          decoration: const InputDecoration(
                            labelText: '*Soil Origin',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          dropdownColor: Colors.green.shade50,
                          items: originType
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                        item), //style: const TextStyle(color: Colors.green)),
                                  ))
                              .toList(),
                          onChanged: (item) {
                            if (item == 'Transported Soil') {
                              visibleTransported = true;
                              _residualController.text = '';
                            } else {
                              visibleTransported = false;
                              selecetedTransport = null;
                            }
                            setState(
                              () {
                                mustIgnore = false;
                                selectedOriginType = item;
                              },
                            );
                          },
                          validator: (title) {
                            if (title == null) {
                              return '*Soil Origin is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                   // dropdown 2: Transported origin
                  Visibility(
                    visible: visibleTransported,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: IgnorePointer(
                            ignoring: mustIgnore,
                            child: DropdownButtonFormField<String>(
                              value: selecetedTransport,
                              decoration: const InputDecoration(
                                labelText: '*Transported Soil',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                              ),
                              dropdownColor: Colors.green.shade50,
                              items: transpotOrigin.map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              ).toList(),
                              onChanged: (item) => setState(
                                    () {
                                      selecetedTransport = item;
                                    },
                                  ),
                              validator: (title) {
                                if (title == null) {
                                  return '*Transported Soil is required';
                                }
                                return null;
                              }
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // text field: residual origin
                  Visibility(
                    visible: !visibleTransported,
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLines: 4,
                          controller: _residualController,
                          decoration: const InputDecoration(
                            labelText: 'Residual Soil',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                          ),
                          // validator: (title) =>
                          //     title != null && title.isEmpty ? 'Enter $text' : null,
                        ),
                      ),
                    ),
                  ),

                  //* depth: number textfield
                  sectionHeading('Layer Depth'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customTextField4('Depth (m)', _depthController),
                  ),

                  //* samples taken: number textfield
                  sectionHeading('Sample Taken'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // switch
                      SizedBox(
                        height: 70,
                        width: 100,
                        child: SwitchListTile(
                          value: visibleSMPL,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (val) => setState(() {
                            visibleSMPL = val;
                            if (visibleSMPL == false) {
                              _smplController.text = '0.0';
                            }
                          }),
                        ),
                      ),
                      // textfield
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: 200,
                          child: Visibility(
                            visible: visibleSMPL,
                            child: customTextField4('Sample depth (m)', _smplController),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //* notes: text field
                  sectionHeading('Additional Notes'),
                  customTextField2('Notes', _notesController),
                  const SizedBox(height: 8)
                ],
              ),
            ),
          ),
        ),

        //! bottom bar
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Container(
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
      ),
    );
  }

  //!create/save button
  Widget buildSaveButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? ' Save' : ' Create';

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ButtonStyle(elevation: MaterialStateProperty.all(8)),
        child: Row(
          children: [
            const Icon(Icons.save_alt_rounded, size: 20),
            Text(text, style: const TextStyle(fontSize: 16)),
          ],
        ),
        onPressed: () async {
          selectedSoilTypes = exportSoilTypeValues(
              primTypeMap, secTypeMap, _otherSoilTypeController.text);
          final String? originItem;

          final isValid = layerFormKey.currentState!.validate();

          if (isValid) {
            final depth = double.tryParse(_depthController.text) ?? 0;
            final moisture = selectedMoisture ?? '';
            final colour = selectedColour ?? '';
            final otherColour = _otherColourController.text;
            final colourPattern = selectedColourPattern ?? '';
            final consistency = selectedConsistency ?? '';
            final structure = selectedStructure ?? '';
            final originType = selectedOriginType ?? ' ';
            selectedOriginType == 'Transported Soil'
                ? originItem = selecetedTransport
                : originItem = _residualController.text;
            final origin = originItem ?? ' ';
            final notes = _notesController.text;
            final smpl = double.tryParse(_smplController.text) ?? 0;

            if (kDebugMode) {
              print('1 $depth');
              print('2 $moisture');
              print('3 $colour');
              print('4 $otherColour');
              print('5 $colourPattern');
              print('6 $consistency');
              print('7 $structure');
              print('8 ${selectedSoilTypes.toString()}');
              print('9 $originType');
              print('10 $origin');
              print('11 $smpl');
              print('12 $notes');
            }

            widget.onClickedDone(
                depth,
                moisture,
                colour,
                otherColour,
                colourPattern,
                consistency,
                structure,
                selectedSoilTypes,
                origin,
                originType,
                smpl,
                notes);

            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  //! extract soil type data from check boxes
  List<String> exportSoilTypeValues(Map<String, bool> map1, Map<String, bool> map2, String other) {
    List<String> result = [];

    map1.forEach((key, value) {
      if (value) {
        result.add(key);
      }
    });

    if (other.isNotEmpty && visibleOtherST) {
      result.add(other);
    }

    map2.forEach((key, value) {
      if (value) {
        result.add(key);
      }
    });

    if (result.isEmpty){
      result.add('UNSPECIFIED');
    }

    return result;
  }

  //! soil type checkbox group
  Widget checkBoxGroup(List<String> list, Map<String, bool> map) {
    return SizedBox(
      child: Column(
        children: [...list.map((e) => customCheckBox(e, map))],
      ),
    );
  }

  //! soil type checkbox
  Widget customCheckBox(String key, Map<String, bool> map) {
    return SizedBox(
      width: 165,
      child: CheckboxListTile(
        // controlAffinity: ListTileControlAffinity.leading,
        title: Text(key, maxLines: 2),
        value: map[key],
        onChanged: ((val) {
          setState(() => map[key] = val!);
        }),
      ),
    );
  }
}
