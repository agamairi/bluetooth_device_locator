import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  // Define your UUIDs (either dynamically generated or hardcoded)
  final Uuid serviceUuid;
  final Uuid characteristicUuid;

  BleService({required this.serviceUuid, required this.characteristicUuid});

  // Scan for devices advertising the custom service UUID
  Stream<DiscoveredDevice> scanForDevices() {
    return _ble.scanForDevices(
      withServices: [serviceUuid],
      scanMode: ScanMode.lowLatency,
    );
  }

  // Connect to a device
  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    );
  }

  // Write a message to the connected device
  Future<void> writeMessage(String deviceId, String message) async {
    await _ble.writeCharacteristicWithResponse(
      QualifiedCharacteristic(
        serviceId: serviceUuid,
        characteristicId: characteristicUuid,
        deviceId: deviceId,
      ),
      value: message.codeUnits, // Convert string to bytes
    );
  }

  // Read messages from the connected device
  Stream<List<int>> readMessages(String deviceId) {
    return _ble.subscribeToCharacteristic(
      QualifiedCharacteristic(
        serviceId: serviceUuid,
        characteristicId: characteristicUuid,
        deviceId: deviceId,
      ),
    );
  }
}
