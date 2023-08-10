import 'package:hive/hive.dart';

import 'hive_test_screen.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0; // Unique ID for the User type

  @override
  User read(BinaryReader reader) {
    int numOfAddresses = reader.readByte();
    List<Address> addressList = [];

    for (int i = 0; i < numOfAddresses; i++) {
      addressList.add(AddressAdapter().read(reader));
    }

    return User(
      name: reader.readString(),
      email: reader.readString(),
      addressList: addressList,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeByte(obj.addressList.length);

    for (Address address in obj.addressList) {
      AddressAdapter().write(writer, address);
    }

    writer.writeString(obj.name);
    writer.writeString(obj.email);
  }
}

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 1; // Unique ID for the Address type

  @override
  Address read(BinaryReader reader) {
    return Address(
      reader.readString(),
      reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer.writeString(obj.village);
    writer.writeString(obj.thana);
  }
}
