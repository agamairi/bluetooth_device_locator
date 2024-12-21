// lib/BleServices.dart

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleServices {
  List<BluetoothDevice> devicesList = [];
  bool isScanning = false;

  // Get the list of paired devices
  Future<List<BluetoothDevice>> getPairedDevices() async {
    return await FlutterBluePlus.bondedDevices;
  }

  Future<List<BluetoothDevice>> getConnectedDevices() async {
    return FlutterBluePlus.connectedDevices;
  }

  // Start scanning for previously paired devices only
  Future<void> startScan() async {
    isScanning = true;
    // Get the list of paired devices
    List<BluetoothDevice> pairedDevices = await getPairedDevices();
    List<BluetoothDevice> connectedDevices = await getConnectedDevices();

    // Start scanning with the desired filters, if any paired devices are found
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    await Future.delayed(const Duration(seconds: 4), () {
      FlutterBluePlus.stopScan();
    });

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        // Check if the scanned device is in the list of paired devices
        if ((pairedDevices.contains(result.device) ||
                connectedDevices.contains(result.device)) &&
            !devicesList.contains(result.device)) {
          devicesList.add(result.device);
        }
      }
    });
  }

  // Stop scanning for devices
  Future<void> stopScan() async {
    isScanning = false;
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
