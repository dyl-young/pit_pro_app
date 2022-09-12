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
void editJob(Job job, String jobNum, String jobTitle, List<TrialPit> trialPits) {
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
Future addTrialPit(String number, List<double> coords, double elevation, List<Layer> layers) async {
  final TrialPit trialPit = TrialPit()
    ..pitNumber = number
    ..createdDate = DateTime.now()
    ..coordinates = coords
    ..elevation = elevation
    ..layersList = layers;

  final box = Boxes.geTrialPits();
  box.add(trialPit);
}

//*edit Trial Pit
void editTrialPit(TrialPit trialPit, String number, List<double> coords, double elevation, List<Layer> layers) {
  trialPit.pitNumber = number;
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
Future addLayer(double depth, String moisture, String colour, String consistency, String structure, List<String> soilTypes, double wt, double pwt, double pm) async {
  final Layer layer = Layer()
    ..depth = depth
    ..moisture = moisture
    ..colour = colour
    ..consistency = consistency
    ..structure = structure
    ..soilTypes = soilTypes
    ..wtDepth = wt
    ..pwtDepth = pwt
    ..pmDepth = pm;

  final box = Boxes.getLayers();
  box.add(layer);
}

//*edit layer
void editLayer(Layer layer, double depth, String moisture, String colour, String consistency, String structure, List<String> soilTypes, double wt, double pwt, double pm) {
  layer.depth = depth;
  layer.moisture = moisture;
  layer.colour = colour;
  layer.consistency = consistency;
  layer.structure = structure;
  layer.soilTypes = soilTypes;
  layer.wtDepth = wt;
  layer.pwtDepth = pwt;
  layer.pmDepth = pm;

  layer.save();
}

//*delete layer
void deleteLayer(Layer layer) {
  layer.delete();
}
