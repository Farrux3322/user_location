import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_location/providers/tab_box_provider.dart';
import 'package:user_location/ui/map/map_screen.dart';
import 'package:user_location/ui/user_locations/user_locations.dart';

class TabBox extends StatefulWidget {
  const TabBox({super.key});

  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  List<Widget> screens = [];

  @override
  void initState() {
    screens.add(MapScreen());
    screens.add(UserLocationsScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<TabBoxProvider>().activeIndex,
        children: screens,
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color(0xFF9B9B9B),
          selectedItemColor:  Colors.white,
          onTap: (index) {
            context.read<TabBoxProvider>().changeIndex(index);
          },
          currentIndex: context.read<TabBoxProvider>().activeIndex,
          // currentIndex: provider.currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined, size: 30), label: "Map"),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_pin, size: 30), label: "User Location"),

          ],
        ),
      ),
    );
  }
}


