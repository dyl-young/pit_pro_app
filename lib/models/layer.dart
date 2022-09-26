import 'package:hive/hive.dart';

part 'layer.g.dart';

@HiveType(typeId: 3)
class Layer extends HiveObject {
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
  double? wtDepth = 0;
  @HiveField(8)
  double? pwtDepth = 0;
  @HiveField(9)
  late double? pmDepth;
  @HiveField(10)
  late String? notes;
  @HiveField(11)
  late DateTime createdDate;
  @HiveField(12)
  late String? originType;
  @HiveField(13)
  late String? colourPattern;

  String soilToString() {
    List<String> revSoilTypes = soilTypes.reversed.toList();
    String result = soilTypes.isNotEmpty ? revSoilTypes[0]: ' ';
    List<String> sec = ['Silty', 'Gravelly', 'Sandy', 'Clayey'];
    // List<String> prim = ['Silt', 'Gravel', 'Sand', 'Clay'];

    if (revSoilTypes.length > 1) {
      for (int i = 1; i < revSoilTypes.length; i++) {

        if(sec.contains(revSoilTypes[i]) || sec.contains(revSoilTypes[i-1])){
          result += ' ${revSoilTypes[i]}';
        } else if (i >= 1) {
          result += ' and ${revSoilTypes[i]}';
        }
      }
    }
    return result;
  }
}
