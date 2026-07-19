import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPickerField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final String helpText;

  const MonthPickerField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.validator,
    this.helpText = 'เลือกเดือน',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_month),
      ),
      validator:
          validator ??
          (value) => value == null || value.isEmpty ? 'กรุณาเลือกเดือน' : null,
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(now.year - 2),
          lastDate: DateTime(now.year + 2),
          helpText: helpText,
        );
        if (picked != null) {
          final value = DateFormat('yyyy-MM').format(picked);
          controller.text = value;
          onChanged?.call(value);
        }
      },
    );
  }
}
