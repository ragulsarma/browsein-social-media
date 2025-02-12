import 'package:hive/hive.dart';

class Database<T> {
  final String boxName;
  final Box<T> box;

  Database({required this.boxName}) : box = Hive.box<T>(boxName);

  Box<T> get getBox => box;
}
