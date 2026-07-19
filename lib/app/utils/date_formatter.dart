import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _display = DateFormat('dd/MM/yyyy');
  static final DateFormat _month = DateFormat('yyyy-MM');

  static String display(String value) {
    if (value.isEmpty) return '-';
    return _display.format(DateTime.parse(value));
  }

  static String month(DateTime value) => _month.format(value);

  static String formatBillingMonth(String value) {
    if (value.isEmpty) return '-';
    try {
      final parts = value.split('-');
      if (parts.length >= 2) {
        final year = int.tryParse(parts[0]) ?? 0;
        final month = int.tryParse(parts[1]) ?? 0;
        if (year > 0 && month >= 1 && month <= 12) {
          final thaiMonths = [
            'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
            'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
          ];
          final thaiYear = year + 543;
          return '${thaiMonths[month - 1]} $thaiYear';
        }
      }
      final date = DateTime.parse(value.contains('-01') ? value : '$value-01');
      final thaiMonths = [
        'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
        'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
      ];
      final thaiYear = date.year + 543;
      return '${thaiMonths[date.month - 1]} $thaiYear';
    } catch (_) {
      return value;
    }
  }
}
