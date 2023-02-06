import 'package:flutter/material.dart';

class FaceRecognitionPage extends StatefulWidget {
  final VoidCallback onPressed;

  FaceRecognitionPage({required this.onPressed});

  @override
  FaceRecognitionState createState() => FaceRecognitionState();
}

class FaceRecognitionState extends State<FaceRecognitionPage> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('登陆'),
      onPressed: widget.onPressed,
    );
  }
}
