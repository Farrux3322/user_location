import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_location/data/location_user_model.dart';
import 'package:user_location/provider/location_user_provider.dart';
import 'package:user_location/save_location_user_screen.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key, required this.latLng});
  final LatLng latLng;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  late  CameraPosition _kGooglePlex;
  late  CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(widget.latLng.latitude, widget.latLng.longitude),
    zoom: 14.4746,
  );
  late CameraPosition currentCameraPosition;

  @override
  void initState() {
    currentCameraPosition = CameraPosition(target: LatLng(widget.latLng.latitude,widget.latLng.longitude));
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.latLng.latitude, widget.latLng.longitude),
      zoom: 14.4746,
    );
    // TODO: implement initState
    super.initState();
  }

  MapType mapType = MapType.normal;
  int i = 1;

  bool onCameraMoveStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SaveLocationUserScreen()));
          }, icon: Icon(Icons.save_as_outlined))
        ],
        title: Text("Maps"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.all(8),
            onCameraMove: (CameraPosition cameraPosition){
              currentCameraPosition = cameraPosition;
            },
            onCameraIdle: (){
              setState(() {
                onCameraMoveStarted = false;
              });
            },
            onCameraMoveStarted: (){
              setState(() {
                onCameraMoveStarted = true;
              });
            },
            mapType: mapType,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child:Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                  border: Border.all(color: Colors.black)
              ),
                child: IconButton(onPressed: (){
                  setState(() {
                    i++;
                    if(i%4==0){
                      mapType = MapType.terrain;
                    }
                    if(i%4==1){
                      mapType = MapType.satellite;
                    }
                    if(i%4==2){
                      mapType = MapType.hybrid;
                    }
                    if(i%4==3){
                      mapType = MapType.normal;
                    }
                  });
                },icon: Icon(Icons.remove_red_eye_outlined,size: 32,color: Colors.black,),)) ,
          ),
          Positioned(
              bottom: 20,
              left: 140,
              right: 140,
              child: SizedBox(
                height: 50,
                child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.black,
            ),
            onPressed: ()async{

         context.read<LocationUserProvider>().insertLocationUser(context: context,locationUserModel: LocationUserModel(lat: currentCameraPosition.target.latitude, long: currentCameraPosition.target.longitude, city: "Quvasoy", created: DateTime.now().toString()));
            },child:const Text("Save",style: TextStyle(color: Colors.white,fontSize: 24),),),
              )),
          Align(
            child: Icon(Icons.location_pin,color: Colors.red,size: onCameraMoveStarted? 70:42),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _goToTheLake,
        child:const  Icon(Icons.gps_fixed_sharp,color: Colors.white,),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}