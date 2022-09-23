import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BCategories extends StatelessWidget {
  String name;
  String? imageUrl;
  double radius;
  bool isSelected;

  BCategories({
    this.imageUrl,
    required this.name,
    this.radius = 24,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 4,
        end: 4,
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: (imageUrl != ''
                  ? CachedNetworkImage(
                fadeInDuration: Duration(microseconds: 100),
                fadeOutDuration: Duration(microseconds: 100),
                placeholderFadeInDuration: Duration(microseconds: 100),

                //fit: BoxFit.contain,
                imageUrl: imageUrl!,
                imageBuilder: (context, imageProvider) => Container(
                  /* width: 42,
                        height: 42,*/
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //color: Colors.black12,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  /*width: 42,
                        height: 42,*/
                  child: Center(
                    child: Icon(
                      Icons.category,
                      size: 42,
                      color: Colors.grey,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 42,
                  height: 42,
                  color: Colors.grey.withOpacity(0.2),
                  child: Center(
                    child: Icon(
                      Icons.error,
                      size: 42,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              )
                  : Icon(
                Icons.category,
                size: 42,
                color: Colors.grey,
              )),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: (isSelected ? Colors.blue : Colors.white),
                width: 2.0,
              ),
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            width: 80,
            child: Text(
              name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: (isSelected ? Colors.blue : Colors.black),
                fontSize: 12,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
