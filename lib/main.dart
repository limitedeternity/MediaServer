import 'package:flutter/material.dart';
import './app.dart';

void main() {
  return runApp(new MediaServer());
}

class MediaServer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "MediaServer",
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF333333),
        accentColor: Colors.redAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: new Application(),
    );
  }
}
