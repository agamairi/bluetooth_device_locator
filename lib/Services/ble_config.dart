import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  // To track discovered devices
  final List<DiscoveredDevice> discoveredDevices = [];

  // Scan for BLE devices emitting a specific service UUID
  Stream<DiscoveredDevice> scanForDevices(String serviceUuid) {
    return _ble.scanForDevices(
      withServices: [Uuid.parse(serviceUuid)],
      scanMode: ScanMode.lowLatency,
    );
  }

  // Connect to a BLE device
  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    );
  }

  // Send a message
  Future<void> writeMessage(
      String deviceId, Uuid characteristicUuid, String message) async {
    await _ble.writeCharacteristicWithResponse(
        QualifiedCharacteristic(
          serviceId: Uuid.parse("service-uuid"),
          characteristicId: characteristicUuid,
          deviceId: deviceId,
        ),
        value: message.codeUnits);
  }

  // Listen for messages
  Stream<List<int>> readMessages(String deviceId, Uuid characteristicUuid) {
    return _ble.subscribeToCharacteristic(QualifiedCharacteristic(
      serviceId: Uuid.parse("service-uuid"),
      characteristicId: characteristicUuid,
      deviceId: deviceId,
    ));
  }
}
