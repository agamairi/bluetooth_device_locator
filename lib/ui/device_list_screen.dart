import 'package:ble_locator/ui/device_location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceDiscoveryPage extends StatefulWidget {
  const DeviceDiscoveryPage({super.key});

  @override
  State<DeviceDiscoveryPage> createState() => _DeviceDiscoveryPageState();
}

class _DeviceDiscoveryPageState extends State<DeviceDiscoveryPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devicesList = [];
  late BluetoothDevice connectedDevice;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  // Start scanning for devices
  void startScan() async {
    // Start scanning with the desired filters
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devicesList.contains(result.device)) {
          setState(() {
            devicesList.add(result.device);
          });
        }
      }
    });

    FlutterBluePlus.isScanning.listen((isScanning) {
      setState(() {
        this.isScanning = isScanning;
      });
    });
  }

  // Stop scanning for devices
  void stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // Connect to a device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceLocationPage(device: device),
        ),
      );
    } catch (e) {
      print("Error connecting to device: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to connect to device')),
      );
    }
  }

  @override
  void dispose() {
    stopScan();
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
                stopScan();
                startScan();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          if (isScanning)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = devicesList[index];
                return Card(
                  child: ListTile(
                    title: Text(device.advName.isEmpty
                        ? 'Unknown device'
                        : device.advName),
                    subtitle: Text(device.remoteId.toString()),
                    trailing: ElevatedButton(
                      onPressed: () => connectToDevice(device),
                      child: const Text('Connect'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
