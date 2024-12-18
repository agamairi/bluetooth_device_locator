import 'dart:math';

class LocationService {
  // Kalman filter variables for smoothing RSSI values
  double _kalmanEstimate = 0.0;
  double _kalmanErrorCovariance = 1.0;
  final double _kalmanMeasurementNoise = 1.0;
  final double _kalmanProcessNoise = 0.1;

  // Method to apply Kalman filter on RSSI value for smoothing
  void applyKalmanFilter(double measuredValue) {
    double predictedEstimate = _kalmanEstimate;
    double predictedErrorCovariance =
        _kalmanErrorCovariance + _kalmanProcessNoise;

    double kalmanGain = predictedErrorCovariance /
        (predictedErrorCovariance + _kalmanMeasurementNoise);
    _kalmanEstimate =
        predictedEstimate + kalmanGain * (measuredValue - predictedEstimate);
    _kalmanErrorCovariance = (1 - kalmanGain) * predictedErrorCovariance;
  }

  // Method to calculate distance from the Bluetooth device based on RSSI
  num calculateDistanceFromRssi(int rssi) {
    double A = -50; // RSSI at 1 meter
    double n = 2.0; // Path loss exponent
    num distance = pow(10, (A - rssi) / (10 * n));
    return distance < 0.5
        ? 0.5
        : distance; // Minimum distance set to 0.5 meters
  }

  // Method to track if user is getting closer or moving away based on RSSI values
  String trackMovementDirection(int rssiValue, int previousRssiValue) {
    if (rssiValue > previousRssiValue) {
      return 'You are getting closer to the device';
    } else if (rssiValue < previousRssiValue) {
      return 'You are moving away from the device';
    } else {
      return 'You are at the same distance from the device';
    }
  }

  // Method to return the smoothed RSSI value
  double get smoothedRssi => _kalmanEstimate;
}
