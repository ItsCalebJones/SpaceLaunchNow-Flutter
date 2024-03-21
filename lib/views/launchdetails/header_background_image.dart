import 'dart:ui';

import 'package:flutter/material.dart';

class HeaderBackgroundImage extends StatelessWidget {
  const HeaderBackgroundImage({super.key, required this.image, required this.context});

  final String image;
  final BuildContext context;


  @override
  Widget build(BuildContext context) {
    double imageHeight;
    double imageWidth;
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    imageWidth = MediaQuery.of(context).size.width;
    if (isTablet){
      imageHeight = MediaQuery.of(context).size.width / 2;
    } else {
      imageHeight = 300;
    }

      return ClipPath(
        clipper: DiagonalClipper(),
        child: Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).colorScheme.background,
              height: imageHeight,
              width: imageWidth,
            ),
            Image.network(
              image,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.fitWidth,
            ),
            Positioned(
              top: 10,
              bottom: 150,
              left: 30,
              right: 100,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20,),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 40);

    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEndPoint = Offset(size.width, size.height - 40.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 2, size.height);
    var secondEndPoint = Offset(size.width, size.height - 40.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}