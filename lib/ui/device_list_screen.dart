import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../services/ble_service.dart';
import 'messaging_screen.dart';

class DeviceListScreen extends StatefulWidget {
  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  final BleService _bleService = BleService(
    serviceUuid:
        Uuid.parse("12345678-1234-5678-1234-56789abcdef0"), // Example UUID
    characteristicUuid: Uuid.parse("abcdef01-1234-5678-1234-56789abcdef0"),
  );

  List<DiscoveredDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    _startScanning();
  }

  void _startScanning() {
    _bleService.scanForDevices().listen((device) {
      if (!_devices.any((d) => d.id == device.id)) {
        setState(() {
          _devices.add(device);
        });
      }
    });
  }

  void _connectToDevice(String deviceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingScreen(
          bleService: _bleService,
          deviceId: deviceId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BLE Devices")),
      body: ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          return ListTile(
            title: Text(device.name.isNotEmpty ? device.name : "Unknown"),
            subtitle: Text(device.id),
            onTap: () => _connectToDevice(device.id),
          );
        },
      ),
    );
  }
}
