# Bluetooth Device Locator  

A Flutter-based application to help you locate your Bluetooth devices with ease. Whether it’s your watch, earphones, or any other Bluetooth accessory, this app uses RSSI (Received Signal Strength Indicator) and Kalman filters to estimate the distance between you and the device, guiding you in the right direction.  

## 🌟 Features  
- **Distance Estimation**: Provides a rough estimate of the distance (in feet) to your Bluetooth device using RSSI and signal processing.  
- **Direction Feedback**: Indicates whether you’re moving closer to or further from the device.  
- **Modern UI**: Built with Material 3 design principles for a clean, intuitive, and responsive user interface.  

## ⚙️ How It Works  
1. The app scans for nearby Bluetooth devices and identifies the target device.  
2. RSSI values are captured and processed using a Kalman filter to smooth out noise.  
3. A simple conversion formula translates RSSI values into approximate distance.  
4. The app updates the user with directional feedback, helping locate the device efficiently.  

## 🧩 Challenges  
- **Indoor Mapping**: Pinpointing the exact location of the device isn’t feasible using Bluetooth alone.  
- **Accuracy**: While the distance estimation is fairly accurate, it isn’t precise due to environmental factors like walls and interference.  

## 🚀 Future Plans  
To overcome the challenges, I’m exploring the integration of the phone’s accelerometer and gyroscope. By comparing motion data with RSSI trends, I aim to provide a rough direction to further refine the device's location.  
