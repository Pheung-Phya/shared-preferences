import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthMiddleware extends GetMiddleware {
  final GetStorage storage = GetStorage();

  @override
  RouteSettings? redirect(String? route) {
    final isLoggedIn = storage.read('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      return const RouteSettings(name: '/login');
    }
    return null; // Allow navigation if authenticated
  }
}
