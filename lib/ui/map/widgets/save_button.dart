import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
class SaveButton extends StatelessWidget {
  const SaveButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical:10,horizontal: 30),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),color: Colors.black
        ),
        child: Text("Save",style: TextStyle(fontSize: 24,color: Colors.white),),
      ),
    );
  }
}
