import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/api_client.dart';

class AuthRepo {
  final _storage = const FlutterSecureStorage();

  // Future<bool> login(String email, String password) async {
  //   try {
  //     final response = await ApiClient.dio.post("/auth/login", data: {
  //       "email": email,
  //       "password": password,
  //     });

  //     await _storage.write(key: "token", value: response.data["token"]);
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<bool> login(String email, String password) async {
  try {
    final response = await ApiClient.dio.post("/auth/login", data: {
      "email": email,
      "password": password,
    });

    final token = response.data["data"]["token"];  // FIXED
    await _storage.write(key: "token", value: token);

    return response.data["success"] == true;
  } catch (e) {
    print("LOGIN ERROR: $e");
    return false;
  }
}

  Future<bool> register(String name, String email, String password) async {
  try {
    final response = await ApiClient.dio.post("/auth/register", data: {
      "name": name,
      "email": email,
      "password": password,
    });

    final token = response.data["data"]["token"];  // FIXED
    await _storage.write(key: "token", value: token);

    return response.data["success"] == true;
  } catch (e) {
    print("REGISTER ERROR: $e");
    return false;
  }
}

}
