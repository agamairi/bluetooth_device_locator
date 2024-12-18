// lib/BleServices.dart

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleServices {
  List<BluetoothDevice> devicesList = [];
  bool isScanning = false;

  // Start scanning for devices
  Future<void> startScan() async {
    // Start scanning with the desired filters
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    // Listen to scan results
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.contains(result.device)) {
          devicesList.add(result.device);
        }
      }
    });

    // Listen to scanning status
    FlutterBluePlus.isScanning.listen((isScanning) {
      this.isScanning = isScanning;
    });
  }

  // Stop scanning for devices
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // Connect to a device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      return true;
    } catch (e) {
      print("Error connecting to device: $e");
      return false;
    }
  }
}
