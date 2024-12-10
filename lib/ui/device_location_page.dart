import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceLocationPage extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceLocationPage({super.key, required this.device});

  @override
  _DeviceLocationPageState createState() => _DeviceLocationPageState();
}

class _DeviceLocationPageState extends State<DeviceLocationPage> {
  int rssiValue = 0;

  @override
  void initState() {
    super.initState();
    startRssiReading();
  }

  void startRssiReading() async {
    while (true) {
      await widget.device.readRssi().then((value) {
        setState(() {
          rssiValue = value;
        });
      });
      await Future.delayed(
          const Duration(seconds: 1)); // Adjust the interval as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Device Name: ${widget.device.name}'),
            Text('Device Address: ${widget.device.id}'),
            Text('RSSI: $rssiValue'),
            // Add navigation instructions based on RSSI and other sensor data
            Text('Navigation Instruction: Move closer to the device'),
          ],
        ),
      ),
    );
  }
}
