import 'package:hive/hive.dart';
import 'layer.dart';

part 'trial_pit.g.dart';

//TODO: add wt and pwt back to Trial Pit structure

@HiveType(typeId: 2)
class TrialPit extends HiveObject {
  @HiveField(0)
  late String pitNumber;
  @HiveField(1)
  late DateTime createdDate; //?  TODO:check how this behaves with changes
  @HiveField(2)
  late List<double> coordinates = List.filled(2, 0.0); //?  TODO:check how this behaves with changes
  @HiveField(3)
  late double? elevation = 0;      //?  TODO:check how this behaves with changes
  @HiveField(4)
  late double? wtDepth = 0;
  @HiveField(5)
  late double? pwtDepth = 0;
  @HiveField(6)
  late List<Layer> layersList;

  double totalDepth() => layersList.fold(
      0, (previousValue, Layer layer) => previousValue + layer.depth);

}
