import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:user_location/data/location_user_model.dart';
import 'package:user_location/providers/user_locations_provider.dart';
import 'package:user_location/ui/user_locations/widgets/user_location_detail_screen.dart';
import 'package:user_location/ui/user_locations/widgets/user_location_update_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class UserLocationsScreen extends StatefulWidget {
  const UserLocationsScreen({super.key});

  @override
  State<UserLocationsScreen> createState() => _UserLocationsScreenState();
}

class _UserLocationsScreenState extends State<UserLocationsScreen> {
  @override
  Widget build(BuildContext context) {
    List<UserAddress> userAddresses =
        Provider.of<UserLocationsProvider>(context).addresses;

    var provider = Provider.of<UserLocationsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Locations Screen"),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: SizedBox(
                          height: 125,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Delete This All Location",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Roboto"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Are you sure you want to delete all Location!",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No")),
                                  TextButton(
                                      onPressed: () {
                                        provider.deleteAllAddress();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "All Location success deleted!")));
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.delete_outline_outlined,
                color: Colors.white,
                size: 30,
              ))
        ],
      ),
      body: ListView(
        children: [
          if (userAddresses.isEmpty)
            Center(child: Lottie.asset("assets/images/empty.json")),
          ...List.generate(userAddresses.length, (index) {
            UserAddress userAddress = userAddresses[index];
            return Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black, blurRadius: 5)
                  ]),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserLocationDetailScreen(
                              latLng:
                                  LatLng(userAddress.lat, userAddress.long))));
                },
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 125,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Delete This Location",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Roboto"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Are you sure you want to delete  Location!",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Roboto"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No")),
                                      TextButton(
                                          onPressed: () {
                                            provider.deleteUserAddress(
                                                userAddress.id!);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Location success deleted!")));
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(color: Colors.red),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.delete_outline_outlined,
                    color: Colors.red,
                  ),
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ZoomTapAnimation(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserLocationUpdateScreen(
                                        userAddress: userAddress,)));
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 32,
                          color: Colors.blue,
                        )),
                    const Spacer(),
                    Text(userAddress.created.substring(0, 16)),
                  ],
                ),
                title: Text(
                  userAddress.address,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
