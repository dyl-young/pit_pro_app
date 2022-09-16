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

  List<TrialPit> getFromBox() {
    List<TrialPit> pits = [];
    TrialPit pit = TrialPit();
    print('hello');
    for (int i = 0; i < trialPitList.length; i++) {
      print('i');
      Boxes.geTrialPits().get(trialPitList[i].key) != null
          ? pits.add(Boxes.geTrialPits().get(trialPitList[i].key) as TrialPit)
          : pits.add(pit);
    }
    print(pits.length);
    print('bye');
    return pits;
  }

  // List<dynamic> getTrialPitKeys() {
  //   List<dynamic> keys = [];
  //   keys.add(trialPitList.map((e) => e.key));
  //   return keys;
  // }

  // Job(this.jobNumber, this.jobTitle);
}
