import 'package:flutter/material.dart';
import 'dart:ui'; // Import the dart:ui library

class CustomOverlayMessage {
  static OverlayEntry? _overlayEntry;

  static void showOverlayMessage(BuildContext context, String message) {
    // Create a GlobalKey for the overlay to dismiss it later
    final overlayKey = GlobalKey<_OverlayMessageState>();

    _overlayEntry = OverlayEntry(
      builder: (context) => OverlayMessage(
        key: overlayKey,
        message: message,
        onDispose: () {
          _overlayEntry = null; // Reset the overlay entry when it is disposed
        },
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);

    // Hide the overlay after a certain duration
    Future.delayed(Duration(seconds: 60), () {
      _overlayEntry?.remove();
    });
  }
}

class OverlayMessage extends StatefulWidget {
  final String message;
  final VoidCallback? onDispose;

  OverlayMessage({Key? key, required this.message, this.onDispose})
      : super(key: key);

  @override
  _OverlayMessageState createState() => _OverlayMessageState();
}

class _OverlayMessageState extends State<OverlayMessage> {
  @override
  void dispose() {
    widget.onDispose?.call(); // Call onDispose when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300, // Adjust the width as needed
          height: 300, // Adjust the height as needed
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    CustomOverlayMessage._overlayEntry?.remove();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
