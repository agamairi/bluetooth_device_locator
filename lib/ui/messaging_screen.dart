// import 'package:flutter/material.dart';
// import '../services/ble_service.dart';

// class MessagingScreen extends StatefulWidget {
//   final BleService bleService;
//   final String deviceId;

//   MessagingScreen({required this.bleService, required this.deviceId});

//   @override
//   State<MessagingScreen> createState() => _MessagingScreenState();
// }

// class _MessagingScreenState extends State<MessagingScreen> {
//   String _receivedMessage = "";

//   @override
//   void initState() {
//     super.initState();
//     _readMessages();
//   }

//   void _readMessages() {
//     widget.bleService.readMessages(widget.deviceId).listen((data) {
//       setState(() {
//         _receivedMessage = String.fromCharCodes(data);
//       });
//     });
//   }

//   void _sendMessage(String message) async {
//     await widget.bleService.writeMessage(widget.deviceId, message);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Messaging")),
//       body: Column(
//         children: [
//           Text("Connected to: ${widget.deviceId}"),
//           TextField(
//             onSubmitted: _sendMessage,
//             decoration: const InputDecoration(labelText: "Enter Message"),
//           ),
//           Text("Received: $_receivedMessage"),
//         ],
//       ),
//     );
//   }
// }
