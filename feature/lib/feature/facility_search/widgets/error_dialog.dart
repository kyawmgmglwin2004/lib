import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "指定した施設IDが存在しません。",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
