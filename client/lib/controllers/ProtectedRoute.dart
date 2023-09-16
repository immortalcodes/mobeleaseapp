import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart'; // Import your AuthController

class ProtectedPage extends StatelessWidget {
  final Widget child;

  ProtectedPage({required this.child});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = AuthController(); // Create an instance of AuthController

    return FutureBuilder<bool>(
      future: authController.isAuthenticated(), // Check if the user is authenticated
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While checking authentication status, display a loading indicator or splash screen
          return CircularProgressIndicator();
        } else if (snapshot.hasError || !snapshot.data!) {
          // If the user is not authenticated, navigate to the login page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return Container(); // You can return an empty container while navigating
        } else {
          // If the user is authenticated, display the protected content (the 'child' widget)
          return child;
        }
      },
    );
  }
}
