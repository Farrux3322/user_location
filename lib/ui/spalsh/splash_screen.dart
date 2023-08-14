import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:user_location/providers/location_provider.dart';
import 'package:user_location/ui/tab_box.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _init() async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return TabBox();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    if (locationProvider.latLong != null) {
      _init();
    }
    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/images/splash_logo.json"),
      ),
    );
  }
}
