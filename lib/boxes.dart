import 'package:hive/hive.dart';
import 'package:pit_pro_app/models/layer.dart';
import 'package:pit_pro_app/models/trial_pit.dart';

import 'models/job.dart';
import 'models/user.dart';

class Boxes {
  static Box<User> getUsers() => Hive.box<User>('users');
  static Box<Job> getJobs() => Hive.box<Job>('jobs');
  static Box<TrialPit> geTrialPits() => Hive.box<TrialPit>('trialPits');
  static Box<Layer> getLayers() => Hive.box<Layer>('layers');
}
