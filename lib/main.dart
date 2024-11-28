import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BluetoothDevice> discoveredDevices = [];

  @override
  void initState() {
    super.initState();
    startScanning();
  }

  Future<void> startScanning() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    // Listen for discovered devices
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        print('results from scan: $result');
        // Add new devices to the list (filter duplicates)
        if (!discoveredDevices.contains(result.device)) {
          setState(() {
            print('result = ${result.device.advName}');
            discoveredDevices.add(result.device);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('BLE Chat'),
            backgroundColor: Colors.blue,
          ),
          body: Column(
            children: [
              ElevatedButton(
                onPressed: startScanning,
                child: const Text('Scan'),
              ),
              // Display list of discovered devices
              ListView.builder(
                shrinkWrap: true,
                itemCount: discoveredDevices.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(discoveredDevices[index].platformName),
                ),
              ),
            ],
          ),
        ),
      );
}
