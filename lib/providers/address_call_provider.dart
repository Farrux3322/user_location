import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:user_location/data/universal_data.dart';
import 'package:user_location/network/api_service.dart';

class AddressCallProvider with ChangeNotifier {
  AddressCallProvider({required this.apiService});

  final ApiService apiService;
  MapType type=MapType.hybrid;
  Set<Marker> markers = {};
  String scrollAddressText = "";
  String kind = "house";
  String lang = "uz_Uz";

  bool canSaveAddress() {
    if (scrollAddressText.isEmpty) return false;
    if (scrollAddressText == 'Aniqlanmagan Hudud') return false;

    return true;
  }

  getAddressByLatLong({
    required LatLng latLng,
  }) async {
    UniversalData universalData =
    await apiService.getAddress(latLng: latLng,kind: kind, lang: lang);

    if (universalData.error.isEmpty) {
      print("--------------+++++++"+universalData.data);
      scrollAddressText = universalData.data as String;
    } else {
      debugPrint("ERROR: ${universalData.error}");
    }

    notifyListeners();
  }
  void updateKind(String newKind){
    kind=newKind;
  }
  void updateLang(String newLang){
    lang=newLang;
  }
  void updateMapType(MapType newMapType){
    type=newMapType;
    notifyListeners();
  }
  addStreamMarker(LocationData locationData)async{
    Uint8List unint8list= await getBytesFromAsset("assets/images/location.png",200);
    markers.add(
      Marker(markerId: MarkerId(locationData.time!.toString()),
        icon: BitmapDescriptor.fromBytes(unint8list),
        position: LatLng(locationData.latitude!,locationData.longitude!),
        infoWindow: InfoWindow(title: locationData.satelliteNumber.toString()),
      ),
    );
    notifyListeners();
  }
  addTwoMarker(LatLng locationData)async{
    Uint8List unint8list= await getBytesFromAsset("assets/images/location.png",200);
    markers.add(
      Marker(markerId: MarkerId(DateTime.now().toString()),
        icon: BitmapDescriptor.fromBytes(unint8list),
        position: LatLng(locationData.latitude,locationData.longitude),
        infoWindow: const InfoWindow(title: "Where you walk"),
      ),
    );
    notifyListeners();
  }
  clearMarker(LatLng latLng)async{
    markers.clear();
  }

}




Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
