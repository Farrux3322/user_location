import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:user_location/data/location_user_model.dart';
import 'package:user_location/providers/address_call_provider.dart';
import 'package:user_location/providers/user_locations_provider.dart';
import 'package:user_location/ui/map/widgets/address_kind_selector.dart';
import 'package:user_location/ui/map/widgets/address_lang_selector.dart';
import 'package:user_location/ui/user_locations/widgets/update_button.dart';
import 'package:user_location/utils/constans.dart';

class UserLocationUpdateScreen extends StatefulWidget {
  const UserLocationUpdateScreen({super.key, required this.userAddress});

  final UserAddress userAddress;

  @override
  State<UserLocationUpdateScreen> createState() => _UserLocationUpdateScreenState();
}

class _UserLocationUpdateScreenState extends State<UserLocationUpdateScreen> {
  late CameraPosition initialCameraPosition;
  late CameraPosition currentCameraPosition;
  bool onCameraMoveStarted = false;

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  @override
  void initState() {

    initialCameraPosition = CameraPosition(
      target: LatLng(widget.userAddress.lat,widget.userAddress.long),
      zoom: 13,
    );

    currentCameraPosition = CameraPosition(
      target: LatLng(widget.userAddress.lat,widget.userAddress.long),
      zoom: 13,
    );

    super.initState();
  }
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Google Map",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          DropdownButtonHideUnderline(
              child: DropdownButton(
                borderRadius: BorderRadius.circular(16),
                icon: const Icon(
                  Icons.layers_outlined,
                  color: Colors.white,
                ),
                onChanged: (v) {
                  setState(() {
                    mapType = v!;
                  });
                },
                items: maps.map((MapType mapType) {
                  return DropdownMenuItem(
                      value: mapType,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                                "assets/images/${mapsTypeName[mapType.name]}.png"),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(mapsTypeName[mapType.name]),
                          ],
                        ),
                      ));
                }).toList(),
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onCameraMove: (CameraPosition cameraPosition) {
              currentCameraPosition = cameraPosition;
            },
            onCameraIdle: () {
              debugPrint(
                  "CURRENT CAMERA POSITION: ${currentCameraPosition.target.latitude}");

              context
                  .read<AddressCallProvider>()
                  .getAddressByLatLong(latLng: currentCameraPosition.target);

              setState(() {
                onCameraMoveStarted = false;
              });

              debugPrint("MOVE FINISHED");
            },
            liteModeEnabled: false,
            myLocationEnabled: false,
            padding: const EdgeInsets.all(16),
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            mapType: mapType,
            onCameraMoveStarted: () {
              setState(() {
                onCameraMoveStarted = true;
              });
              debugPrint("MOVE STARTED");
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: initialCameraPosition,
          ),
          Align(
            child: Icon(
              Icons.location_pin,
              color: Colors.black,
              size: onCameraMoveStarted ? 70 : 52,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
              child: Text(
                context.watch<AddressCallProvider>().scrollAddressText,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: AddressKindSelector(),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: AddressLangSelector(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: context.watch<AddressCallProvider>().canSaveAddress(),
              child: UpdateButton(onTap: () {
                AddressCallProvider adp =
                Provider.of<AddressCallProvider>(context, listen: false);
                context.read<UserLocationsProvider>().updateUserAddress(
                  UserAddress(
                    id: widget.userAddress.id,
                    lat: currentCameraPosition.target.latitude,
                    long: currentCameraPosition.target.longitude,
                    address: adp.scrollAddressText,
                    created: DateTime.now().toString(),
                  ),
                );
                if(context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.black,duration: Duration(milliseconds: 1500),content: Center(child: Text("Updated",style: TextStyle(fontSize: 24,color: Colors.white),))));
              }),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _followMe(cameraPosition: initialCameraPosition);
        },
        child: const Icon(Icons.gps_fixed),
      ),
    );
  }

  Future<void> _followMe({required CameraPosition cameraPosition}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }
}
