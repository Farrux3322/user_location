import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:user_location/data/location_user_model.dart';
import 'package:user_location/provider/location_user_provider.dart';
class SaveLocationUserScreen extends StatefulWidget {
  const SaveLocationUserScreen({super.key});

  @override
  State<SaveLocationUserScreen> createState() => _SaveLocationUserScreenState();
}

class _SaveLocationUserScreenState extends State<SaveLocationUserScreen> {
  @override
  Widget build(BuildContext context) {

    var provider = Provider.of<LocationUserProvider>(context);
    return Scaffold(
      appBar: AppBar(
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
                              Text(
                                "Delete This All Location",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Are you sure you want to delete all Location!",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto"),
                              ),
                              SizedBox(
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
                                        provider.deleteAllLocationUsers(context: context);
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
              icon: Icon(
                Icons.delete_outline_outlined,
                color: Colors.white,
                size: 30,
              ))
        ],
        title:const Text("Saved"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body:provider.locationUser.isNotEmpty? Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Expanded(child: ListView(
              children: [
                ...List.generate(provider.locationUser.length, (index){
                  LocationUserModel locationUserModel = provider.locationUser[index];
                  return Container(
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,blurRadius: 5
                        )
                      ]
                    ),
                    child: ListTile(
                      leading: IconButton(padding: EdgeInsets.zero,onPressed: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: SizedBox(
                                  height: 125,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Delete This Location",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Roboto"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Are you sure you want to delete  Location!",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto"),
                                      ),
                                      SizedBox(
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
                                                provider.deleteLocationUser(id: locationUserModel.id!);
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
                      },icon: Icon(Icons.delete_outline_outlined,color: Colors.red,),),
                      trailing: Text(locationUserModel.created.substring(0,16)),
                      title: Text("City : ${locationUserModel.city}",style: TextStyle(fontSize: 20),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Lot: ${locationUserModel.lat}",style: TextStyle(fontSize: 10),),
                          Text("Long: ${locationUserModel.long}",style: TextStyle(fontSize: 10),),
                        ],
                      ),
                    ),
                  );

                })
              ],
            ))
          ],
        ),
      ): Center(child: Lottie.asset("assets/images/empty.json")),
    );
  }
}
