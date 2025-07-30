import 'package:flutter/material.dart';
import 'map_page.dart';

void main() {
  runApp(const TrackRunApp());
}

class TrackRunApp extends StatelessWidget {
  const TrackRunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackRun',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MapPage(),
    );
  }
}
