import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:user_location/network/api_service.dart';
import 'package:user_location/providers/address_call_provider.dart';
import 'package:user_location/ui/spalsh/splash_screen.dart';

import 'providers/location_provider.dart';
import 'providers/tab_box_provider.dart';
import 'providers/user_locations_provider.dart';

Future<void> main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserLocationsProvider()),
      ChangeNotifierProvider(create: (context) => TabBoxProvider()),
      ChangeNotifierProvider(create: (context) => LocationProvider()),
      ChangeNotifierProvider(create: (context) => AddressCallProvider(apiService: ApiService())),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
