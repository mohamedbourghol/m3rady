import 'package:flutter/material.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';

class BEliteCompany extends StatelessWidget {
  int id;
  String imageUrl;
  String name;
  double radius;

  BEliteCompany({
    required this.id,
    required this.imageUrl,
    required this.name,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: WUserImage(
              imageUrl,
              isElite: true,
              radius: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 7, end: 7),
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
