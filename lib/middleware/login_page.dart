import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginPage extends StatelessWidget {
  final GetStorage storage = GetStorage();

  LoginPage({Key? key}) : super(key: key);

  void _login() {
    storage.write('isLoggedIn', true);
    Get.offNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: _login,
          child: const Text('Login'),
        ),
      ),
    );
  }
}
