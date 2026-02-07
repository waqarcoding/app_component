/// core/utils/toast_utils.dart
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToastUtils {
  static void showJSON(String message){
    developer.log(jsonEncode(message));
  }
  static void show(BuildContext context, String message) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
