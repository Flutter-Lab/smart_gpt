import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'chat_model.dart';

class HiveTestScreen extends StatefulWidget {
  const HiveTestScreen({super.key});

  @override
  State<HiveTestScreen> createState() => _HiveTestScreenState();
}

class _HiveTestScreenState extends State<HiveTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // SizedBox(height: 50),
            ElevatedButton(onPressed: () {}, child: Text('Add Data')),
            ElevatedButton(onPressed: () {}, child: Text('Update Data')),
            ElevatedButton(onPressed: () {}, child: Text('Get Data')),
            ElevatedButton(onPressed: () {}, child: Text('Delete Data')),
            ElevatedButton(
                onPressed: () {
                  chatHiveFunction();
                },
                child: Text('Hive Test'))
          ],
        ),
      ),
    );
  }

  void chatHiveFunction() async {
    var chatBox = await Hive.openBox<Chat>('chatBox');

    var chatMessage1 = ChatMessage(msg: 'Hello', senderIndex: 0);
    var chatMessage2 = ChatMessage(msg: 'Hi there', senderIndex: 1);

    var chat = Chat(
      chatMessageList: [chatMessage1, chatMessage2],
      lastUpdateTime: DateTime.now().toString(),
    );

    await chatBox.add(chat);

    var currentChat = chatBox.getAt(0);
    print(currentChat!.chatMessageList[1].msg);
  }

  void hiveFunction() async {
    var userBox = await Hive.openBox<User>('users');

    // Save a User
    var user = User(
      name: 'Alice',
      email: 'alice@example.com',
      addressList: [Address('Village 1', 'Thana 1')],
    );
    await userBox.add(user);

    // Retrieve a User
    var retrievedUser = userBox.getAt(0);
    print('Retrieved User: ${retrievedUser?.name}, ${retrievedUser?.email}');

    // Update a User
    retrievedUser?.name = 'Alicia';
    retrievedUser?.addressList.add(Address('Village 2', 'Thana 2'));
    retrievedUser?.save();

    // Delete a User
    retrievedUser?.delete();

    // Close Hive
    await Hive.close();
  }
}

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final List<Address> addressList;

  User({required this.name, required this.email, required this.addressList});
}

@HiveType(typeId: 1)
class Address extends HiveObject {
  @HiveField(0)
  final String village;

  @HiveField(1)
  final String thana;

  Address(this.village, this.thana);
}
