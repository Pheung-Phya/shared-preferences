import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatelessWidget {
  final GetStorage storage = GetStorage();

  HomePage({Key? key}) : super(key: key);

  void _logout() {
    storage.remove('isLoggedIn'); // Remove the login state
    Get.offAllNamed(
        '/login'); // Navigate to the login page and clear the navigation stack
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Call the logout function
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout, // Logout using the FAB
        child: const Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}
