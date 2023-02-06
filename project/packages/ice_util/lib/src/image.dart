import 'dart:math';

import 'package:image/image.dart';

List<int> generateDefaultUserAvatar(String userIdFirstLetter) {
  Image image = Image(36, 36);

  // Fill it with a solid color (blue)
  fill(
      image,
      getColor(
          Random().nextInt(255), Random().nextInt(255), Random().nextInt(255)));

  // Draw some text using 24pt arial font
  drawString(image, arial_24, 11, 6, userIdFirstLetter);

  // Draw a line
  // drawLine(image, 0, 0, 320, 240, getColor(255, 0, 0), thickness: 3);

  // Blur the image
  // gaussianBlur(image, 10);

  // Save the image to disk as a PNG
  final data = encodePng(image);
  return data;
}
