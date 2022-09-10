import 'package:hive/hive.dart';
import 'layer.dart';

part 'trial_pit.g.dart';

@HiveType(typeId: 2)
class TrialPit {
  @HiveField(0)
  final String pitNumber;
  @HiveField(1)
  final DateTime createdDate;
  @HiveField(2)
  final List<double> coordinates = List.filled(2, 0.0);
  @HiveField(3)
  final double elevation;
  @HiveField(4)
  final double wtDepth;
  @HiveField(5)
  final double pwtDepth;
  @HiveField(6)
  final double pmDepth;
  @HiveField(7)
  late final List<Layer> layersList;

  TrialPit(this.pitNumber, this.createdDate, this.elevation, this.wtDepth,
      this.pwtDepth, this.pmDepth);

  double totalDepth() => layersList.fold(
      0, (previousValue, Layer layer) => previousValue + layer.depth);

}
