import 'package:flutter/material.dart';
import 'package:pit_pro_app/components/custom_text_field.dart';
import 'package:pit_pro_app/components/layer_properties.dart';

import '../components/buttons.dart';
import '../models/layer.dart';

//TODO: FIX LAYER DELETE!!!!!!
//TODO: FIX SAVE BUTON ON EDIT PAGE

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
      String originType,
      // double wt,
      // double pwt,
      double pm,
      String notes) onClickedDone;

  @override
  State<LayerFormPage> createState() => _LayerFormPageState();
}

class _LayerFormPageState extends State<LayerFormPage> {
  final layerFormKey = GlobalKey<FormState>();

  //*Note wt and pwt will be set in pdf gen
  //*Layer Attributes  (values to pass to addLayer on save)

  //?implemented:
  //TODO: check final vs late vs ? changes
  //depth
  final _depthController = TextEditingController();
  //moisture
  String? selectedMoisture;
  //colour
  String? selectedColour;
  //consistency
  String? selectedConsistency;
  String? selectedConsistencyType;
  //structure
  String? selectedStructure;
  //notes
  final _notesController = TextEditingController();
  //soil types
  List<String> selectedSoilTypes = [];
  //origin
  String? selectedOriginType;
  String? selecetedTransport;
  final _residualController = TextEditingController();
  //pm
  final _pmController = TextEditingController();

  //* Pedefined layer properties
  //?implemented
  //moisture
  final List<String> moisture = SoilMoisture().getSoilMoisture();
  //colour
  final List<String> colour = SoilColour().getSoilColour();
  //consistency
  final List<String> cohesiveConsistency =
      SoilConsistency().getCohesiveConsistency();
  final List<String> granularConsistency =
      SoilConsistency().getGranularConsistency();
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
  final List<String> transpotOrigin =
      TransportedSoilOrigin().getTransportedSoil();
  bool visibleTransported = true;
  bool mustIgnore = true;
  //pm
  bool visiblePM = false;

  //*Initialise method
  @override
  void initState() {
    if (widget.layer != null) {
      final layer = widget.layer;

      //depth
      _depthController.text = layer!.depth.toString();
      //Moisture
      selectedMoisture = layer.moisture;
      //colour
      selectedColour = layer.colour;
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
      //type
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
      //pm
      if (layer.pmDepth != 0) {
        visiblePM = true;
        _pmController.text = layer.pmDepth.toString();
      } else {
        _pmController.text = '0.0';
      }
    }

    super.initState();
  }

  //* Dispose method
  @override
  void dispose() {
    _depthController.dispose();
    _notesController.dispose();
    _pmController.dispose();
    _residualController.dispose();
    super.dispose();
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.layers_rounded),
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                          // dropdownColor: Colors.green.shade100,
                          value: selectedMoisture, //_moistureController.text,
                          decoration: const InputDecoration(
                            labelText: '*Soil Moisture Condition',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          dropdownColor: Colors.green.shade50,
                          items: moisture
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                        item), //style: const TextStyle(color: Colors.green)),
                                  ))
                              .toList(),
                          onChanged: (item) => setState(
                                () {
                                  selectedMoisture = item;
                                },
                              ),
                          validator: (title) {
                            if (title == null) {
                              return '*Soil Moisture Condition is required';
                            }
                          }),
                    ),
                  ),
                ),

                //! Colour: dropdown
                //TODO: Implement secondary colour description
                sectionHeading('Soil Colour'),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                          // dropdownColor: Colors.green.shade100,
                          value: selectedColour, //_moistureController.text,
                          decoration: const InputDecoration(
                            labelText: '*Soil Colour',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          dropdownColor: Colors.green.shade50,
                          items: colour
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                        item), //style: const TextStyle(color: Colors.green)),
                                  ))
                              .toList(),
                          onChanged: (item) => setState(
                                () {
                                  selectedColour = item;
                                },
                              ),
                          validator: (title) {
                            if (title == null) {
                              return '*Soil Colour is required';
                            }
                          }),
                    ),
                  ),
                ),

                //! Consistency: multilevel dropdown
                //* multilevel drop-down menu
                sectionHeading('Soil Consistency'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 180,
                        child: DropdownButtonFormField<String>(
                          // hint: const Text('Select'),
                          dropdownColor: Colors.green.shade50,
                          decoration: const InputDecoration(
                            labelText: 'Select',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                          ),
                          value: selectedConsistencyType,
                          items: consistencyType
                              .map((item) => DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (item) => setState(() {
                            switch (item) {
                              case 'Cohesive':
                                consistency = cohesiveConsistency;
                                break;
                              case 'Granular':
                                consistency = granularConsistency;
                                break;
                              default:
                            }
                            selectedConsistencyType = item;
                            selectedConsistency = null;
                          }),
                        ),
                      ),
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
                          // hint: const Text('Soil Consistency'),
                          items: consistency
                              .map((item) => DropdownMenuItem(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (item) => setState(() {
                            selectedConsistency = item;
                          }),
                          validator: (title) {
                            if (title == null) {
                              return '*Consistency is required';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                //! Structure: dropdown
                sectionHeading('Soil Structure'),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                          // dropdownColor: Colors.green.shade100,
                          value: selectedStructure, //_moistureController.text,
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
                          }),
                    ),
                  ),
                ),

                //! Soil Types: check box/radio button group
                sectionHeading('Soil Types'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    checkBoxGroup(primSoilTypes, primTypeMap),
                    checkBoxGroup(secSoilTypes, secTypeMap)
                  ],
                ),

                //! Origin: drop down -> dropdown or -> textField
                sectionHeading('Soil Origin'),
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
                          }),
                    ),
                  ),
                ),
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
                              items: transpotOrigin
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ))
                                  .toList(),
                              onChanged: (item) => setState(
                                    () {
                                      selecetedTransport = item;
                                    },
                                  ),
                              validator: (title) {
                                if (title == null) {
                                  return '*Transported Soil is required';
                                }
                              }),
                        ),
                      ),
                    ),
                  ),
                ),
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

                //! Pebble Marker: numeric textfield
                sectionHeading('Pebble Marker'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 100,
                      child: SwitchListTile(
                        value: visiblePM,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (val) => setState(() {
                          visiblePM = val;
                          if (visiblePM == false) {
                            _pmController.text = '0.0';
                          }
                        }),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Visibility(
                        visible: visiblePM,
                        child: customTextField4(
                            'Pebble Marker (m)', _pmController),
                      ),
                    ),
                  ],
                ),

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
        ),
        onPressed: () async {
          selectedSoilTypes = exportSoilTypeValues(primTypeMap, secTypeMap);
          final isValid = layerFormKey.currentState!.validate();
          final String? originItem;

          if (isValid) {
            final depth = double.tryParse(_depthController.text) ?? 0;
            final moisture = selectedMoisture ?? '';
            final colour = selectedColour ?? '';
            final consistency = selectedConsistency ?? '';
            final structure = selectedStructure ?? '';
            final originType = selectedOriginType??' ';
            selectedOriginType == 'Transported Soil'
                ? originItem = selecetedTransport
                : originItem = _residualController.text;
            final origin = originItem ?? ' ';
            final notes = _notesController.text;
            final pm = double.tryParse(_pmController.text) ?? 0;

            print('1 $depth');
            print('2 $moisture');
            print('3 $colour');
            print('4 $consistency');
            print('5 $structure');
            print('6 ${selectedSoilTypes.toString()}');
            //TODO: implement a way to know whethere origin variable is residual or transported
            print('7 $origin');
            print('8 $pm');
            print('9 $notes');

            widget.onClickedDone(depth, moisture, colour, consistency,
                structure, selectedSoilTypes, origin, originType, pm, notes);

            Navigator.of(context).pop();
          }
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
              validator: (title) {
                if (title == null) {
                  return '$label is required';
                }
              }),
        ),
      ),
    );
  }

  //! Origin type drop-down menu
  Widget originDropDownMenu(
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
              onChanged: (item) {
                item == 'Transported Soil'
                    ? visibleTransported = true
                    : visibleTransported = false;
                setState(
                  () {
                    mustIgnore = false;
                    selectedItem = item;
                  },
                );
              },
              validator: (title) {
                if (title == null) {
                  return '$label is required';
                }
              }),
        ),
      ),
    );
  }

  //! Check Boxes for soil types
  List<String> exportSoilTypeValues(
      Map<String, bool> map1, Map<String, bool> map2) {
    List<String> result = [];

    map1.forEach((key, value) {
      if (value) {
        result.add(key);
      }
    });

    map2.forEach((key, value) {
      if (value) {
        result.add(key);
      }
    });

    return result;
  }

  Widget checkBoxGroup(List<String> list, Map<String, bool> map) {
    return SizedBox(
      height: 60 * list.length / 1,
      width: 165,
      child: Column(
        children: [...list.map((e) => customCheckBox(e, map))],
      ),
    );
  }

  Widget customCheckBox(String key, Map<String, bool> map) {
    return SizedBox(
      width: 170,
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
