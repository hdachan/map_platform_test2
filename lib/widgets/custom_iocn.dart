import 'package:flutter/material.dart';

Widget myLocationButton(VoidCallback onTap) {
  return Positioned(
    bottom: 24,
    left: 16,
    child: GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20,
        child: Icon(
          Icons.my_location,
          color: Colors.black,
        ),
      ),
    ),
  );
}