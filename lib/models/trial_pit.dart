import 'package:hive/hive.dart';
import 'layer.dart';

part 'trial_pit.g.dart';

@HiveType(typeId: 2)
class TrialPit extends HiveObject {
  @HiveField(0)
  late String pitNumber;
  @HiveField(1)
  late DateTime createdDate; //?  TODO:check how this behaves with changes
  @HiveField(2)
  late List<double> coordinates = List.filled(2, 0.0); //?  TODO:check how this behaves with changes
  @HiveField(3)
  late final double elevation;      //?  TODO:check how this behaves with changes
  @HiveField(4)
  late List<Layer> layersList;

  double totalDepth() => layersList.fold(
      0, (previousValue, Layer layer) => previousValue + layer.depth);

}
