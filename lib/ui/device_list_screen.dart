import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/ble_service.dart';
import 'messaging_screen.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

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

  Future<bool> _requestPermissions() async {
    // Request both location and Bluetooth permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    // Check if all permissions are granted
    return statuses[Permission.location]?.isGranted == true &&
        statuses[Permission.bluetoothScan]?.isGranted == true &&
        statuses[Permission.bluetoothConnect]?.isGranted == true;
  }

  void _startScanning() async {
    bool permissionsGranted = await _requestPermissions();

    if (permissionsGranted) {
      _bleService.scanForDevices().listen((device) {
        if (!_devices.any((d) => d.id == device.id)) {
          setState(() {
            _devices.add(device);
          });
        }
      });
    } else {
      // Inform user to enable permissions
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Permissions are required to scan for BLE devices.")),
      );
    }
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
      appBar: AppBar(
        title: const Text("BLE Devices"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _startScanning(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
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
