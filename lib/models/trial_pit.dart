import 'package:hive/hive.dart';
import 'layer.dart';

part 'trial_pit.g.dart';

@HiveType(typeId: 2)
class TrialPit extends HiveObject {
  @HiveField(0)
  late final String pitNumber;
  @HiveField(1)
  late final DateTime createdDate;
  @HiveField(2)
  late final List<double> coordinates = List.filled(2, 0.0);
  @HiveField(3)
  late final double elevation;
  @HiveField(4)
  late final double wtDepth;
  @HiveField(5)
  late final double pwtDepth;
  @HiveField(6)
  late final double pmDepth;
  @HiveField(7)
  late final List<Layer> layersList;

  double totalDepth() => layersList.fold(
      0, (previousValue, Layer layer) => previousValue + layer.depth);

}
