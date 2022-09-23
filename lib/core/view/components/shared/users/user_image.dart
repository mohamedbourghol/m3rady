import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';


class WUserImage extends StatelessWidget {
  String? imageUrl;
  String imagePath;
  double radius;
  bool isElite;

  WUserImage(
      this.imageUrl,
      {
        this.radius = 24,
        this.imagePath='',
        this.isElite = false,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isElite ? Color(0xffFD8200) : Colors.grey.withOpacity(0.5),
        ),
        boxShadow: isElite
        ? [
        BoxShadow(
          blurRadius: 1,
          color: Color(0xffFD8200),
          spreadRadius: 0.5,
        )
        ]
            : null,
      ),
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        clipBehavior: Clip.none,
        children: [
          (   imagePath.length>2?
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey.withOpacity(0.2),
            backgroundImage: FileImage(
              File(
                imagePath,
              ),

            ),
          ):
          imageUrl != null && imageUrl != ''
              ? CachedNetworkImage(
            imageUrl: imageUrl!,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey.withOpacity(0.2),
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.2),
              radius: radius,
              child: CircularProgressIndicator(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.2),
              radius: radius,
              child: Icon(
                Icons.error,
                size: radius,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),

          )
              : Container(
            child: Image(
              image: assets['userDefaultImage'],
              //fit: BoxFit.cover,
            ),
          )),
          Visibility(
            visible: isElite,
            child: Positioned(
              left: -7,
              child: Image(
                image: assets['elites'],
                width: radius / 1.6,
                height: radius / 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}