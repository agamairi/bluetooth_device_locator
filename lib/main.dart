import 'package:ble_locator/ui/app_theme.dart';
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
      theme: buildAppTheme(),
      home:
          const DeviceDiscoveryPage(), // Initial screen showing scanned devices
    );
  }
}
