
import 'package:hive/hive.dart';

part 'layer.g.dart';

@HiveType(typeId: 3)
class Layer extends HiveObject{
  @HiveField(0)
  final double depth;
  @HiveField(1)
  final String moisture;
  @HiveField(2)
  final String colour;
  @HiveField(3)
  final String consistency;
  @HiveField(4)
  final String structure;
  @HiveField(5)
  final List<String> soilTypes;
  @HiveField(6)
  final String origin;
  @HiveField(7)
  final String? note;

  Layer(this.depth, this.moisture, this.colour, this.consistency,
      this.structure, this.soilTypes, this.origin, this.note);

  String soilToString() {
    String result = soilTypes.first;
    for (int i = 1; i < soilTypes.length; i++) {
      result += ' and ${soilTypes[i]}';
    }
    return result;
  }
}
