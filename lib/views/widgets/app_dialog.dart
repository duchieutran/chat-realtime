import 'package:flutter/material.dart';

Future<void> appDialog({
  required BuildContext context,
  required String title,
  required String content,
  bool barrierDismissible = false,
  String confirmText = "OK",
  String cancelText = "Hủy",
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
}) {
  return showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          (onCancel == null)
              ? Container()
              : TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancel();
                  },
                  child: Text(cancelText,
                      style: const TextStyle(color: Colors.grey)),
                ),
          (onConfirm == null)
              ? Container()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    onConfirm();
                  },
                  child: Text(confirmText,
                      style: const TextStyle(color: Colors.white)),
                ),
        ],
      );
    },
  );
}
