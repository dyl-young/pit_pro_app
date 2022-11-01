//* libraries
import 'dart:io';
import 'dart:math';

//* packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pit_pro_app/components/widgets/page_transition.dart';

//* local imports
import 'layer_form_page.dart';
import '../components/widgets/info_textbox_widget.dart';
import '../components/content_builder_widgets/layers_content_builder.dart';
import '../components/widgets/cancelbutton.dart';
import '../components/widgets/custom_text_field.dart';
import '../hive_components/add_edit_delete_functions.dart';
import '../location_services.dart';
import '../hive_components/boxes.dart';
import '../models/layer.dart';
import '../models/trial_pit.dart';

class TrialPitDetailsPage extends StatefulWidget {
  const TrialPitDetailsPage({Key? key, this.trialPit, required this.onClickedDone}): super(key: key);

  //* class arguments
  final TrialPit? trialPit;
  final Function(
      String pitNumber,
      List<double> coords,
      double elevation,
      double wt,
      double pm,
      List<Layer> layersList,
      String contractor,
      String machine,
      String imagePath,
      String notes) onClickedDone;

  @override
  State<TrialPitDetailsPage> createState() => _TrialPitDetailsPageState();
}

class _TrialPitDetailsPageState extends State<TrialPitDetailsPage> {

  //* attributes
  final pitFormKey = GlobalKey<FormState>();
  final _pitNumController = TextEditingController();
  final _xCoordController = TextEditingController();
  final _yCoordController = TextEditingController();
  final _elevationController = TextEditingController();
  final _waterTableController = TextEditingController();
  final _pebbleMarkerController = TextEditingController();
  final _contractorController = TextEditingController();
  final _machineController = TextEditingController();
  final _notesController = TextEditingController();
  final _imagePathController = TextEditingController();
  var location = Location();
  late List<Layer> madeLayers = [];

  //* initialise method
  @override
  void initState() {
    
    //* initialise Trial Pit
    if (widget.trialPit != null) {
      final trialPit = widget.trialPit!;

      //* initialise Layers
      //! Get relevant objects from the object box using the created date
      for (var i = 0; i < Boxes.getLayers().values.toList().length; i++) {
        for (var j = 0; j < trialPit.layersList.length; j++) {
          Boxes.getLayers().values.toList()[i].createdDate ==
                  trialPit.layersList[j].createdDate
              ? madeLayers.add(Boxes.getLayers().values.toList()[i])
              : [];
        }
      }
      //* initialise text controlers
      _pitNumController.text = trialPit.pitNumber;
      _waterTableController.text = trialPit.wtDepth.toString();
      _pebbleMarkerController.text = trialPit.pmDepth.toString();
      _contractorController.text = trialPit.contractor!;
      _machineController.text = trialPit.machine!;
      _xCoordController.text = trialPit.coordinates[0].toString();
      _yCoordController.text = trialPit.coordinates[1].toString();
      _elevationController.text = trialPit.elevation.toString();
      _imagePathController.text = trialPit.imagePath!;
      _notesController.text = trialPit.notes!;
    }
    super.initState();
  }

  //* dispose method
  @override
  void dispose() {
    _pitNumController.dispose();
    _xCoordController.dispose();
    _yCoordController.dispose();
    _elevationController.dispose();
    _waterTableController.dispose();
    _pebbleMarkerController.dispose();
    _contractorController.dispose();
    _machineController.dispose();
    _notesController.dispose();
    _imagePathController.dispose();

    super.dispose();
  }

  //* build method
  @override
  Widget build(BuildContext context) {

    //* image path attribute
    String displayPath = _imagePathController.text != ''
        ? p.basename(_imagePathController.text)
        : '';

    //* title
    final isEditing = widget.trialPit != null;
    final title = isEditing ? 'Edit Trial Pit' : 'Create Trial Pit';

    return WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
        resizeToAvoidBottomInset: false,

        //! appbar
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(angle: pi, child: const Icon(Icons.line_style_outlined)),
              Text(' $title'),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,

          //* cancel button
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: cancelButton(context, madeLayers, !isEditing),
            ),
          ],
        ),

        //! Trial Pit widgets
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(

                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Form(
                      key: pitFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          //* Trial Pit details heading
                          sectionHeading('Trial Pit Details'),

                          //* row 1: trial Pit Number
                          customTextField('*Hole Number', _pitNumController),

                          const SizedBox(height: 16),

                          //* row 2:
                          Padding(
                            padding: const EdgeInsets.fromLTRB(6,0,6,0),
                            child: Row(
                              children: [
                                //* water table
                                Expanded(
                                  child: customTextField3('Water table (m) ', _waterTableController),
                                ),
                                //* pebble marker
                                Expanded(
                                  child: customTextField3('Pebble marker (m) ', _pebbleMarkerController),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          //* row 3:
                          Padding(
                            padding: const EdgeInsets.fromLTRB(6,0,6,0),
                            child: Row(
                              children: [
                                //* contractor
                                Expanded(
                                  child: customTextField5('Contractor', _contractorController),
                                ),
                                //* machine
                                Expanded(
                                  child: customTextField5('Machinery', _machineController),
                                ),
                              ],
                            ),
                          ),

                          //* location heading
                          subSectionHeading('Location Details:'),

                          //* row4:
                          Padding(
                            padding: const EdgeInsets.fromLTRB(6,8,6,0),
                            child: Row(
                              children: [
                                //* x coordinate
                                Expanded(child: customTextField3('Latitude', _xCoordController)),
                                //* y coordinate
                                Expanded(child: customTextField3('Longitude', _yCoordController)),
                                //* elevation
                                Expanded(child: customTextField3('Elevation (m)', _elevationController)),
                              ],
                            ),
                          ),
                          
                          //* location autofill button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [autoFillButton()]
                          ),

                          //* row 5: Trial Pit image
                          subSectionHeading('Trial Pit Image:'),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  //* image path textbox/ image view buton button
                                  child: infoTextBox2('', displayPath),
                                  onTap: () {
                                    _imagePathController.text != ''
                                    //* display Image
                                    ? showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Trial Pit Image'),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                //delete image button
                                                deleteImageButton(),
                                                //back button
                                                imageBackButton(),
                                              ],
                                            ),
                                          ],

                                          //* image box
                                          content: SizedBox(
                                            height: 400,
                                            width: 300,
                                            //loader with progress indicator
                                            child: FutureBuilder(
                                              future: Future.delayed(const Duration(seconds: 5)),
                                              builder: (c, s) => s.connectionState == ConnectionState.done
                                                  ? Image.file(File(_imagePathController.text))
                                                  : const Center(
                                                    child: SizedBox(
                                                        height: 80,
                                                        width: 80,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 6,
                                                          backgroundColor: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      )
                                    
                                    //* no image display
                                    : showDialog(
                                      context: context,
                                      builder: (context) => const AlertDialog(
                                        title: Center(
                                          child: Text('No Image',style: TextStyle(color: Colors.grey),),
                                        ),
                                        shape:RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                imageButton(),
                              ],
                            ),
                          ),
                          //* row 6: notes section
                          subSectionHeading('Notes:'),
                          customTextField2('Notes', _notesController),

                          //* layers heading
                          subSectionHeading('Layers:'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },

          //* layer card list builder
          body: ValueListenableBuilder<Box<Layer>>(
            valueListenable: Boxes.getLayers().listenable(),
            builder: (context, box, _) {
              return layerListViewBuilder(context, madeLayers);
            },
          ),
        
        ),


        //! floating action button
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).push(
            createRoute(LayerFormPage(
                onClickedDone: (
                  depth,
                  moisture,
                  colour,
                  otherColour,
                  colourPattern,
                  consistency,
                  structure,
                  soilTypes,
                  origin,
                  originType,
                  smpl,
                  notes,
                ) => addLayer(
                  madeLayers,
                  depth,
                  moisture,
                  colour,
                  otherColour,
                  colourPattern,
                  consistency,
                  structure,
                  soilTypes,
                  origin,
                  originType,
                  smpl,
                  notes,
                ),
              ),
            ),
          ),
          label: const Text(' Layer '),
          icon: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        //! bottom nav bar
        bottomNavigationBar: BottomAppBar(
          notchMargin: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //* save button
              buildSaveButton(context, isEditing: isEditing),
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
        ),

        onPressed: () async {
          final isValid = pitFormKey.currentState!.validate();

          if (isValid) {
            final num = _pitNumController.text;
            final wt = double.tryParse(_waterTableController.text) ?? 0;
            final pm = double.tryParse(_pebbleMarkerController.text) ?? 0;
            final xCoord = double.tryParse(_xCoordController.text) ?? 0;
            final yCoord = double.tryParse(_yCoordController.text) ?? 0;
            final elevation = double.tryParse(_elevationController.text) ?? 0;
            final contractor = _contractorController.text;
            final machine = _machineController.text;
            final notes = _notesController.text;
            final imagePath = _imagePathController.text;

            widget.onClickedDone(
              num,
              [xCoord, yCoord],
              elevation,
              wt,
              pm,
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

  //* round double values to 2 decimal points
  double roundDouble(double value) {
    num mod = pow(10.0, 2);
    return ((value * mod).round().toDouble() / mod);
  }

  //! retreive location data
  void getLocation(TextEditingController lat, TextEditingController long, TextEditingController elevation) async {
    final service = LocationServices();
    final locationData = await service.getLocation();

    if (locationData != null) {
      long.text = locationData.longitude!.toStringAsFixed(4);
      lat.text = locationData.latitude!.toStringAsFixed(4);
      elevation.text = locationData.altitude!.toStringAsFixed(2);
    }
  }

  //! autofill location button
  Widget autoFillButton() {
    return SizedBox(
      height: 40,
      child: TextButton(
            onPressed: () {
              getLocation(_xCoordController, _yCoordController, _elevationController);
              final snackBar = SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.grey.shade400,
                content: const Text('Retrieving location details...'),
                duration: const Duration(seconds: 5),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Row(
              children: const [
                Icon(Icons.autorenew_rounded, size: 18),
                Text('Autofill', style: TextStyle(fontSize: 14))
              ],
            ),
          ),
    );
  }

  //! image button
  Widget imageButton() {
    return SizedBox(
      height: 32,
      child: CircleAvatar(
        child: TextButton(
          onPressed: () {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              context: context,
              builder: ((builder) => bottomSheet(context, getImage)),
            );
          },
          child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
        ),
      ),
    );
  }

  //! delete image button
  Widget deleteImageButton(){
    return IconButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) => confirmImageDelete(
            context,
            _imagePathController.text,
            deleteFile,
          ),
        );
      },
      icon: const Icon(Icons.delete),
    );
  }

  //! back button
  Widget imageBackButton(){
    return IconButton(
      onPressed: Navigator.of(context).pop,
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  //! bottom image sheet
  Widget bottomSheet(BuildContext context, Function getImage) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text('Add a Trial Pit Image'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //* camerea button
              TextButton(
                onPressed: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop(); //dismiss bottom sheet
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.camera), Text('Camera')],
                ),
              ),
              //* gallery button
              TextButton(
                onPressed: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop(); //dismiss bottom sheet
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image_outlined),
                    Text('Gallery')
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //! get image file from gallery/camera and save to app
  void getImage(ImageSource source) async {
    XFile? pickedFile;
    final int dateID = DateTime.now().millisecondsSinceEpoch;
    final String imageSource =
        source == ImageSource.camera 
        ? 'camerea_image' 
        : 'gallery_image';

    final File newFile;
    final Directory dir = await getApplicationDocumentsDirectory();
    pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      _imagePathController.text != ''
          ? deleteFile(File(_imagePathController.text))
          : null;

      newFile = await File(pickedFile.path).copy('${dir.path}/$imageSource$dateID${p.extension(pickedFile.path)}');

      setState(() {
        _imagePathController.text = newFile.path;
      });
    }
  }

//! confirm delete image
Widget confirmImageDelete(
    BuildContext context, String path, Function deleteFile) {
  return AlertDialog(
    title: Column(
      children: const [
        Icon(Icons.delete_rounded, size: 40),
        Text('Are you sure?', style: TextStyle(fontSize: 16)),
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //*yes button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            deleteFile(File(path));
            setState(() => _imagePathController.text = ''); //Delete image file
          },
          child: const Text('yes', style: TextStyle(fontSize: 16)),
        ),
        //*no button
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('no', style: TextStyle(fontSize: 16)),
        ),
      ],
    ),
  );
}

}
