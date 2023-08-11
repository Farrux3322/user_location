import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:user_location/data/local_databse.dart';
import 'package:user_location/data/location_user_model.dart';
import 'package:user_location/utils/ui_utils/loading_dialog.dart';
class LocationUserProvider with ChangeNotifier{

  LocationUserProvider(){
    getLocationUser();
    notifyListeners();
  }


  List<LocationUserModel> locationUser=[];

  getLocationUser()async{
    locationUser = await LocalDatabase.getAllLocationUser();
    print("kirdiiiiiiiiiiii ${locationUser.length}");
    notifyListeners();
  }

  deleteLocationUser({required int id})async{
    await LocalDatabase.deleteLocationUser(id);
    await getLocationUser();
    notifyListeners();
  }

  deleteAllLocationUsers({required BuildContext context})async{
    showLoading(context: context);
    await LocalDatabase.deleteAllLocationUsers();
    await getLocationUser();
    if(context.mounted)hideLoading(dialogContext: context);
    notifyListeners();

  }

  insertLocationUser({required BuildContext context,required LocationUserModel locationUserModel})async{
    showLoading(context: context);

    LocationUserModel locationUserModel1 =  await LocalDatabase.insertLocationUser(locationUserModel);

    if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black,duration: Duration(milliseconds: 1500),content: Center(child: Text("Saved",style: TextStyle(fontSize: 24,color: Colors.white),))));
    await getLocationUser();
    if(context.mounted)hideLoading(dialogContext: context);
    notifyListeners();
  }

}