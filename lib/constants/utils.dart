import 'package:flutter/material.dart';

Image customImage(String imagePath, {double? height, width}) {
  return Image(
    height: height ?? 20.0,
    width: width ?? 20.0,
    image: AssetImage(imagePath),
  );
}

extension EmptySpace on num {
  SizedBox get spaceY => SizedBox(
        height: toDouble(),
      );
  SizedBox get spaceX => SizedBox(
        width: toDouble(),
      );
}
