import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projecte/features/merchant/views/product_deal_form/widgets/product_deal_submit_button.dart';

class ProductDealDetailsCard extends StatelessWidget {
  const ProductDealDetailsCard({
    super.key,
    required this.dealType,
    required this.onDealTypeChanged,
    required this.discountType,
    required this.onDiscountTypeChanged,
    required this.discountController,
    required this.quantityController,
    required this.startsController,
    required this.endsController,
    required this.onStartTap,
    required this.onEndTap,
    required this.isSaving,
    required this.onSave,
  });

  final String dealType;
  final ValueChanged<String> onDealTypeChanged;
  final String discountType;
  final ValueChanged<String> onDiscountTypeChanged;
  final TextEditingController discountController;
  final TextEditingController quantityController;
  final TextEditingController startsController;
  final TextEditingController endsController;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;
  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'รายละเอียดโปรโมชัน',
            style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: dealType,
            items: const [
              DropdownMenuItem(
                value: 'FlashDeal',
                child: Text('โปรโมชันพิเศษ'),
              ),
              DropdownMenuItem(value: 'LocalDeal', child: Text('โปรเด็ดชุมชน')),
            ],
            onChanged: (value) {
              if (value != null) onDealTypeChanged(value);
            },
            decoration: const InputDecoration(labelText: 'ประเภทโปรโมชัน'),
          ),
          DropdownButtonFormField<String>(
            initialValue: discountType,
            items: const [
              DropdownMenuItem(
                value: 'Percent',
                child: Text('ลดเป็นเปอร์เซ็นต์'),
              ),
              DropdownMenuItem(
                value: 'FixedAmount',
                child: Text('ลดเป็นจำนวนเงิน'),
              ),
            ],
            onChanged: (value) {
              if (value != null) onDiscountTypeChanged(value);
            },
            decoration: const InputDecoration(labelText: 'รูปแบบส่วนลด'),
          ),
          TextField(
            controller: discountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: discountType == 'Percent'
                  ? 'ส่วนลด (%)'
                  : 'ส่วนลด (บาท)',
            ),
          ),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'จำนวนสิทธิ์ทั้งหมด'),
          ),
          TextField(
            controller: startsController,
            readOnly: true,
            onTap: onStartTap,
            decoration: const InputDecoration(
              labelText: 'วันและเวลาเริ่มต้น',
              hintText: 'แตะเพื่อเลือกวันและเวลา',
              suffixIcon: Icon(Icons.calendar_month_rounded),
            ),
          ),
          TextField(
            controller: endsController,
            readOnly: true,
            onTap: onEndTap,
            decoration: const InputDecoration(
              labelText: 'วันและเวลาสิ้นสุด',
              hintText: 'แตะเพื่อเลือกวันและเวลา',
              suffixIcon: Icon(Icons.calendar_month_rounded),
            ),
          ),
          const SizedBox(height: 18),
          ProductDealSubmitButton(isSaving: isSaving, onPressed: onSave),
        ],
      ),
    );
  }
}
