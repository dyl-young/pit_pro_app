
import 'package:hive/hive.dart';

part 'layer.g.dart';

@HiveType(typeId: 3)
class Layer extends HiveObject{
  @HiveField(0)
  late double depth;
  @HiveField(1)
  late String moisture;
  @HiveField(2)
  late String colour;
  @HiveField(3)
  late String consistency;
  @HiveField(4)
  late String structure;
  @HiveField(5)
  late List<String> soilTypes;
  @HiveField(6)
  late String origin;
   @HiveField(7)
  late double wtDepth;
  @HiveField(8)
  late double pwtDepth;
  @HiveField(9)
  late double pmDepth;
  @HiveField(10)
  late String? note;

  // Layer(this.depth, this.moisture, this.colour, this.consistency,
  //     this.structure, this.soilTypes, this.origin, this.note);

  String soilToString() {
    String result = soilTypes.first;
    for (int i = 1; i < soilTypes.length; i++) {
      result += ' and ${soilTypes[i]}';
    }
    return result;
  }
}
