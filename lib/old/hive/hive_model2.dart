import 'package:hive/hive.dart';

final myBox = Hive.box('myBox');

void insertDB(myList) async {
  await myBox.add(myList);
}

void getDB() async {
  final hiveList = myBox.values.toList();
}

void updateDB(inex, myList) async {
  myBox.put(inex, myList);
}

void deleteDB(index) async {
  myBox.deleteAt(index);
}
