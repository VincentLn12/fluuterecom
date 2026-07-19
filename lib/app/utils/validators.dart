class Validators {
  static String? requiredField(String? value, {String label = 'ข้อมูล'}) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอก$label';
    }
    return null;
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'กรุณากรอกเบอร์โทรศัพท์';
    if (!RegExp(r'^\d{10}$').hasMatch(text)) {
      return 'เบอร์โทรศัพท์ต้องมี 10 หลัก';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'กรุณากรอกอีเมล';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(text)) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
    }
    return null;
  }

  static String? idCard(String? value) {
    final text = value?.trim() ?? '';
    if (!RegExp(r'^\d{13}$').hasMatch(text)) {
      return 'เลขบัตรประชาชนต้องมี 13 หลัก';
    }
    return null;
  }

  static String? nonNegative(String? value, {String label = 'จำนวนเงิน'}) {
    final number = double.tryParse(value ?? '');
    if (number == null) return 'กรุณากรอก$label';
    if (number < 0) return '$labelต้องมากกว่าหรือเท่ากับ 0';
    return null;
  }

  static String? meter({
    required double previous,
    required double current,
    required String label,
  }) {
    if (current < previous) {
      return '$labelปัจจุบันต้องไม่น้อยกว่าครั้งก่อน';
    }
    return null;
  }

  static String? moveOutDate({required DateTime moveIn, DateTime? moveOut}) {
    if (moveOut != null && moveOut.isBefore(moveIn)) {
      return 'วันที่ย้ายออกต้องไม่ก่อนวันที่เข้าอยู่';
    }
    return null;
  }
}
