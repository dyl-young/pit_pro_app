//packages
import 'package:hive/hive.dart';

//local imports
import 'layer.dart';

part 'trial_pit.g.dart';

@HiveType(typeId: 2)
class TrialPit extends HiveObject {
  @HiveField(0)
  late String pitNumber;
  @HiveField(1)
  late DateTime createdDate;
  @HiveField(2)
  late List<double> coordinates = List.filled(2, 0.0);
  @HiveField(3)
  late double? elevation = 0;
  @HiveField(4)
  late double? wtDepth = 0;
  @HiveField(5)
  late double? pwtDepth = 0;
  @HiveField(6)
  late List<Layer> layersList;
  @HiveField(7)
  late String contractor = ' ';
  @HiveField(8)
  late String machine = ' ';
  @HiveField(9)
  late String imagePath = ' ';
  @HiveField(10)
  late String notes = ' ';

  double totalDepth() => layersList.fold(
      0, (previousValue, Layer layer) => previousValue + layer.depth);
}

//TODO: add image of pitt from device