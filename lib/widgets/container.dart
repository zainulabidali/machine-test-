import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  final Widget child; // The content inside the container
  final Color backgroundColor; // Optional background color

  const RoundedContainer({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white, // Default to white
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor, // Background color (default is white)
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), // Top-left border radius
          topRight: Radius.circular(30), // Top-right border radius
        ),
      ),
      child: child, // Place the passed child inside the container
    );
  }
}



class TopNotification {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40.0, // Position from the top of the screen
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay entry to show the notification
    overlay.insert(overlayEntry);

    // Remove the notification after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}