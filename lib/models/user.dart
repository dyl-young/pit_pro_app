import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String userName;
  @HiveField(1)
  final String institutionName;
  @HiveField(2)
  final String institutionLogo;

  User(this.userName, this.institutionName, this.institutionLogo);
}
