import 'package:hive/hive.dart';
import '../hive_components/boxes.dart';
import 'trial_pit.dart';

part 'job.g.dart';

//* Gen adapter command: flutter packages pub run build_runner build --delete-conflicting-outputs  
@HiveType(typeId: 0)
class Job extends HiveObject {
  @HiveField(0)
  late String jobNumber;
  @HiveField(1)
  late String jobTitle;
  @HiveField(2)
  late List<TrialPit> trialPitList;
}
