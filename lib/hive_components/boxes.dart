//packages
import 'package:hive/hive.dart';

//local imports
import '../models/job.dart';
import '../models/layer.dart';
import '../models/trial_pit.dart';
import '../models/user.dart';

// Hive boxes
class Boxes {
  static Box<User> getUsers() => Hive.box<User>('users');
  static Box<Job> getJobs() => Hive.box<Job>('jobs');
  static Box<TrialPit> geTrialPits() => Hive.box<TrialPit>('trialPits');
  static Box<Layer> getLayers() => Hive.box<Layer>('layers');
}
