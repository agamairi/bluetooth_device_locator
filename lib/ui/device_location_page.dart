import 'package:ble_locator/services/location_service.dart';

import 'package:ble_locator/ui/components/semi_circle_progress.dart';
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
  num get estimatedDistance => _locationService.calculateDistanceFromRssi(
        _locationService.smoothedRssi.toInt(),
      );

  // Track movement direction using the LocationService
  void _trackMovement() {
    setState(() {
      _movementFeedback = _locationService.trackMovementDirection(
          _locationService.smoothedRssi.toInt(), previousRssiValue);
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
      body: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Device Info Card (top half)
              SizedBox(
                width: double.maxFinite,
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.device.platformName,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.device.remoteId}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Signal Strength: ${(smoothedRssi + 100) / 80}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Estimated Distance: ${estimatedDistance.toStringAsFixed(2)} feet',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),

              // Semicircular Progress Indicator (bottom half)
              SemicircularProgressIndicator(
                progress: (rssiValue + 100) / 80, // Normalize RSSI (-100 to 0)
                backgroundColor: Colors.grey.shade300,
                progressColor: smoothedRssi > previousRssiValue
                    ? Colors.red
                    : Colors.green,
                estimatedDistance: estimatedDistance.toStringAsFixed(2),
              ),

              // Movement Feedback Section
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),

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
      ),
    );
  }
}
