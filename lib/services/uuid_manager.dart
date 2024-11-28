import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UuidManager {
  final Uuid uuidGenerator = Uuid();

  // Get or generate service UUID
  Future<String> getServiceUuid() async {
    final prefs = await SharedPreferences.getInstance();
    String? serviceUuid = prefs.getString("serviceUuid");

    if (serviceUuid == null) {
      serviceUuid = uuidGenerator.v4(); // Generate if not found
      await prefs.setString("serviceUuid", serviceUuid);
    }
    return serviceUuid;
  }

  // Get or generate characteristic UUID
  Future<String> getCharacteristicUuid() async {
    final prefs = await SharedPreferences.getInstance();
    String? characteristicUuid = prefs.getString("characteristicUuid");

    if (characteristicUuid == null) {
      characteristicUuid = uuidGenerator.v4(); // Generate if not found
      await prefs.setString("characteristicUuid", characteristicUuid);
    }
    return characteristicUuid;
  }
}
