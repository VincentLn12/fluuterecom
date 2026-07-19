class Validators {
  const Validators._();

  static String? requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label ห้ามว่าง';
    }
    return null;
  }

  static String? positiveInt(String? value, String label) {
    final number = int.tryParse(value ?? '');
    if (number == null || number <= 0) {
      return '$label ต้องมากกว่า 0';
    }
    return null;
  }

  static String? zeroOrPositiveInt(String? value, String label) {
    final number = int.tryParse(value ?? '');
    if (number == null || number < 0) {
      return '$label ต้องไม่ติดลบ';
    }
    return null;
  }

  static String? rating(String? value) {
    final number = double.tryParse(value ?? '');
    if (number == null || number < 0 || number > 5) {
      return 'คะแนนต้องอยู่ระหว่าง 0 ถึง 5';
    }
    return null;
  }
}
