import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final Future<void> Function() onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('ยกเลิก')),
        FilledButton(
          onPressed: () async {
            await onConfirm();
            Get.back();
          },
          child: const Text('ยืนยัน'),
        ),
      ],
    );
  }
}
