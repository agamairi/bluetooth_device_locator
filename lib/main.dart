import 'package:flutter/material.dart';
import 'ui/device_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Messaging App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          const DeviceDiscoveryPage(), // Initial screen showing scanned devices
    );
  }
}
