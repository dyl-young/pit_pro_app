import '../models/layer.dart';
import 'boxes.dart';
import '../../models/job.dart';
import '../../models/trial_pit.dart';

//! Job functions
//*add new Job
Future addJob(String jobNum, String jobTitle, List<TrialPit> trialPits) async {
  final Job job = Job()
    ..jobNumber = jobNum
    ..jobTitle = jobTitle
    ..trialPitList = trialPits;

  final box = Boxes.getJobs();
  box.add(job);
}

//*edit existing Job
void editJob(
    Job job, String jobNum, String jobTitle, List<TrialPit> trialPits) {
  job.jobNumber = jobNum;
  job.jobTitle = jobTitle;
  job.trialPitList = trialPits;

  job.save();
}

//*delete existing Job
void deleteJob(Job job) {
  for (var e in job.trialPitList) {
    //deleteTrialpit function also removes its layers
    deleteTrialPit(e);
  }

  job.delete();
}

//! Trial Pit functions
//*add Trial Pit
Future addTrialPit(
    List<TrialPit> trialPits,
    double wt,
    double pwt,
    String number,
    List<double> coords,
    double elevation,
    List<Layer> layers) async {
  final box = Boxes.geTrialPits();
  final TrialPit trialPit = TrialPit()
    ..pitNumber = number
    ..createdDate = DateTime.now()
    ..wtDepth = wt
    ..pwtDepth = pwt
    ..coordinates = coords
    ..elevation = elevation
    ..layersList = layers;

  trialPits.add(trialPit);
  box.add(trialPit);
}

//*edit Trial Pit
void editTrialPit(TrialPit trialPit, double wt, double pwt, String number,
    List<double> coords, double elevation, List<Layer> layers) {
  trialPit.pitNumber = number;
  trialPit.wtDepth = wt;
  trialPit.pwtDepth = pwt;
  trialPit.coordinates = coords;
  trialPit.elevation = elevation;
  trialPit.layersList = layers;

  trialPit.save();
}

//*delete Trial Pit
void deleteTrialPit(TrialPit trialPit) {
  for (var e in trialPit.layersList) {
    deleteLayer(e);
  }

  trialPit.delete();
}

//! Layer functions:
//*add layer
Future addLayer(
    List<Layer> layers,
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
    String notes) async {
  final box = Boxes.getLayers();
  final Layer layer = Layer()
    ..depth = depth
    ..moisture = moisture
    ..colour = colour
    ..consistency = consistency
    ..structure = structure
    ..soilTypes = soilTypes
    ..origin = origin
    ..originType = originType
    // ..wtDepth = wt
    // ..pwtDepth = pwt
    ..pmDepth = pm
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
    String consistency,
    String structure,
    List<String> soilTypes,
    String origin,
    String originType,
    // double wt,
    // double pwt,
    double pm,
    String notes) {
  layer.depth = depth;
  layer.moisture = moisture;
  layer.colour = colour;
  layer.consistency = consistency;
  layer.structure = structure;
  layer.soilTypes = soilTypes;
  layer.originType = originType;
  layer.origin = origin;
  // layer.wtDepth = wt;
  // layer.pwtDepth = pwt;
  layer.pmDepth = pm;
  layer.notes = notes;

  layer.save();
}

//*delete layer
void deleteLayer(Layer layer) {
  layer.delete();
}
