import 'package:ble_locator/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceLocationPage extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceLocationPage({super.key, required this.device});

  @override
  State<DeviceLocationPage> createState() => _DeviceLocationPageState();
}

class _DeviceLocationPageState extends State<DeviceLocationPage> {
  int rssiValue = 0;
  int previousRssiValue = 0;

  // Create an instance of LocationService
  final LocationService _locationService = LocationService();

  // Movement feedback
  String _movementFeedback = 'Start walking toward the device';

  @override
  void initState() {
    super.initState();
    startRssiReading();
  }

  // Start reading RSSI values from the Bluetooth device
  void startRssiReading() async {
    while (true) {
      await widget.device.readRssi().then((value) {
        setState(() {
          previousRssiValue = rssiValue;
          rssiValue = value;

          // Apply Kalman filter to smooth RSSI value
          _locationService.applyKalmanFilter(rssiValue.toDouble());
        });
      });
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // Calculate the distance from the device using the LocationService
  num get estimatedDistance =>
      _locationService.calculateDistanceFromRssi(rssiValue);

  // Track movement direction using the LocationService
  void _trackMovement() {
    setState(() {
      _movementFeedback =
          _locationService.trackMovementDirection(rssiValue, previousRssiValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Smoothed RSSI value
    int smoothedRssi = _locationService.smoothedRssi.toInt();

    // Track movement based on RSSI changes
    _trackMovement();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Device Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Device: ${widget.device.platformName}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Address: ${widget.device.remoteId}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // RSSI Progress Bar
                    LinearProgressIndicator(
                      value:
                          (rssiValue + 100) / 100, // Normalize RSSI (-100 to 0)
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          rssiValue > previousRssiValue
                              ? Colors.green
                              : Colors.red),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Signal Strength: $rssiValue dBm',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Smoothed RSSI: $smoothedRssi dBm',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Estimated Distance: ${estimatedDistance.toStringAsFixed(2)} meters',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Movement Feedback Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Movement Feedback:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _movementFeedback,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
