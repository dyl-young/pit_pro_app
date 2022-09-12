import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  late String userName;
  @HiveField(1)
  late String institutionName;
  @HiveField(2)
  late String institutionLogo;

  User(this.userName, this.institutionName, this.institutionLogo);
}
