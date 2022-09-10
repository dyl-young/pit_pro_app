import 'package:hive/hive.dart';
import 'trial_pit.dart';

part 'job.g.dart';

//flutter packages pub run build_runner build
@HiveType(typeId: 0)
class Job extends HiveObject{
  @HiveField(0)
  late final String jobNumber;
  @HiveField(1)
  late final String jobTitle;
  @HiveField(2)
  late List<TrialPit> trialPitList;

  // Job(this.jobNumber, this.jobTitle);
}
