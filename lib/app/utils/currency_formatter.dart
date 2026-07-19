import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'th_TH',
    symbol: '฿',
    decimalDigits: 0,
  );

  static String format(num value) => _currency.format(value);
}
