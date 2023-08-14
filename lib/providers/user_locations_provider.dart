import 'package:flutter/cupertino.dart';
import 'package:user_location/data/local/local_db.dart';
import 'package:user_location/data/location_user_model.dart';

class UserLocationsProvider with ChangeNotifier {
  List<UserAddress> addresses = [];

  UserLocationsProvider() {
    getUserAddresses();
  }

  getUserAddresses() async {
    addresses = await LocalDatabase.getAllUserAddresses();
    notifyListeners();
  }

  insertUserAddress(UserAddress userAddress) async {
    await LocalDatabase.insertUserAddress(userAddress);
    getUserAddresses();
  }

  updateUserAddress(UserAddress userAddress) async {
    print(userAddress);
    await LocalDatabase.updateUserAddress(userAddress);
    getUserAddresses();
  }

  deleteUserAddress(int id) async {
    await LocalDatabase.deleteUserAddress(id);
    getUserAddresses();
  }

  deleteAllAddress() async {
    await LocalDatabase.deleteAllAddresses();
    getUserAddresses();
  }
}
