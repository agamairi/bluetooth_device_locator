import 'package:ble_locator/services/ble_service.dart';
import 'package:ble_locator/ui/app_theme.dart';
import 'package:ble_locator/ui/components/device_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'device_location_page.dart';

class DeviceDiscoveryPage extends StatefulWidget {
  const DeviceDiscoveryPage({super.key});

  @override
  State<DeviceDiscoveryPage> createState() => _DeviceDiscoveryPageState();
}

class _DeviceDiscoveryPageState extends State<DeviceDiscoveryPage> {
  final BleServices _bleServices =
      BleServices(); // Create an instance of BleServices
  late BluetoothDevice connectedDevice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScan();
    });
  }

  // Start scanning for devices
  void _startScan() async {
    await _bleServices.startScan();
    setState(() {});
  }

  // Stop scanning for devices
  void _stopScan() async {
    await _bleServices.stopScan();
    setState(() {});
  }

  // Connect to a device
  Future<void> _connectToDevice(BluetoothDevice device) async {
    bool success = await _bleServices.connectToDevice(device);
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceLocationPage(device: device),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to device')),
      );
    }
  }

  @override
  void dispose() {
    _stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Discovery'),
        actions: [
          IconButton(
            onPressed: () {
              _stopScan();
              _startScan();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_bleServices.isScanning)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: coffee,
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _bleServices.devicesList.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = _bleServices.devicesList[index];
                return DeviceCard(
                  device: device,
                  onConnect: () => _connectToDevice(device),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
