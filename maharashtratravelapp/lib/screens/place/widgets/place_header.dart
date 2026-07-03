import 'package:flutter/material.dart';

class PlaceHeader extends StatelessWidget {
  final String image;

  const PlaceHeader({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [

        Hero(
          tag: image,
          child: Image.network(
            image,
            height: 320,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 50,
          left: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),

        Positioned(
          top: 50,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(
                Icons.favorite_border,
              ),
              onPressed: () {},
            ),
          ),
        ),

      ],
    );
  }
}