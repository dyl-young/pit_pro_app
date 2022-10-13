//* libraries
import 'dart:io';

//* local imports
import 'boxes.dart';
import '../models/layer.dart';
import '../models/user.dart';
import '../models/job.dart';
import '../models/trial_pit.dart';

//! User functions
//* edit user
void editUser(User user, String name, String company) {
  user.userName = name;
  user.institutionName = company;

  user.save();
}

//! Job functions
//* add Job
Future addJob(String jobNum, String jobTitle, List<TrialPit> trialPits) async {
  final Job job = Job()
    ..jobNumber = jobNum
    ..jobTitle = jobTitle
    ..trialPitList = trialPits;

  final box = Boxes.getJobs();
  box.add(job);
}

//* edit Job
void editJob(Job job, String jobNum, String jobTitle, List<TrialPit> trialPits) {
  job.jobNumber = jobNum;
  job.jobTitle = jobTitle;
  job.trialPitList = trialPits;

  job.save();
}

//* delete existing Job
void deleteJob(Job job) {
  for (var e in job.trialPitList) {
    deleteTrialPit(e);
  }
  job.delete();
}

//! Trial Pit functions
//* add Trial Pit
Future addTrialPit(
    List<TrialPit> trialPits,
    String number,
    List<double> coords,
    double elevation,
    double wt,
    double pm,
    List<Layer> layers,
    String contractor,
    String machine,
    String imagePath,
    String notes) async 
    {
  final box = Boxes.geTrialPits();
  final TrialPit trialPit = TrialPit()
    ..pitNumber = number
    ..createdDate = DateTime.now()
    ..coordinates = coords
    ..elevation = elevation
    ..wtDepth = wt
    ..pmDepth = pm
    ..layersList = layers
    ..contractor = contractor
    ..machine = machine
    ..imagePath = imagePath
    ..notes = notes;

  trialPits.add(trialPit);
  box.add(trialPit);
}

//* edit Trial Pit
void editTrialPit(
    TrialPit trialPit,
    String number,
    List<double> coords,
    double elevation,
    double wt,
    double pm,
    List<Layer> layers,
    String contractor,
    String machine,
    String imagePath,
    String notes) 
    {
  trialPit.pitNumber = number;
  trialPit.coordinates = coords;
  trialPit.elevation = elevation;
  trialPit.wtDepth = wt;
  trialPit.pmDepth = pm;
  trialPit.layersList = layers;
  trialPit.contractor = contractor;
  trialPit.machine = machine;
  trialPit.imagePath = imagePath;
  trialPit.notes = notes;

  trialPit.save();
}

//* delete Trial Pit
void deleteTrialPit(TrialPit trialPit) {
  for (var e in trialPit.layersList) {
    deleteLayer(e);
  }

  if (trialPit.imagePath != '') {
    deleteFile(File(trialPit.imagePath!));
  }

  trialPit.delete();
}

//! Layer functions:
//* add layer
Future addLayer(
    List<Layer> layers,
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
    double pm,
    String notes) async 
    {
  final box = Boxes.getLayers();
  final Layer layer = Layer()
    ..depth = depth
    ..moisture = moisture
    ..colour = colour
    ..otherColour = otherColour
    ..colourPattern = colourPattern
    ..consistency = consistency
    ..structure = structure
    ..soilTypes = soilTypes
    ..origin = origin
    ..originType = originType
    ..smplDepth = pm
    ..notes = notes
    ..createdDate = DateTime.now();
  layers.add(layer);
  box.add(layer);
}

//*edit layer
void editLayer(
    Layer layer,
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
    String notes) 
    {
  layer.depth = depth;
  layer.moisture = moisture;
  layer.colour = colour;
  layer.otherColour = otherColour;
  layer.colourPattern = colourPattern;
  layer.consistency = consistency;
  layer.structure = structure;
  layer.soilTypes = soilTypes;
  layer.originType = originType;
  layer.origin = origin;
  layer.smplDepth = smpl;
  layer.notes = notes;

  layer.save();
}

//*delete layer
void deleteLayer(Layer layer) {
  layer.delete();
}

//! delete image file from app dir
Future<int> deleteFile(File file) async {
  try {
    await file.delete();
  } catch (e) {
    return 0;
  }
  return 1;
}
