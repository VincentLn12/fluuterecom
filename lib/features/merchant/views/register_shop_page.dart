import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../controllers/register_shop_controller.dart';

class RegisterShopPage extends GetView<RegisterShopController> {
  const RegisterShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text(
          'สมัครเปิดร้านค้า',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'กำลังโหลดข้อมูล...');
        }

        final shopStatus = controller.myShop.value?.status;

        if (shopStatus == 'PendingApproval') {
          return _buildPendingApprovalView();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderBanner(),
                const SizedBox(height: 20),
                if (shopStatus == 'Rejected') ...[
                  _buildRejectedBanner(),
                  const SizedBox(height: 20),
                ],
                _buildGeneralInfoSection(),
                const SizedBox(height: 20),
                _buildLocationSection(),
                const SizedBox(height: 20),
                _buildBankSection(),
                const SizedBox(height: 28),
                _buildSubmitButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF047857), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MERCHANT APPLICATION',
            style: GoogleFonts.krub(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF6EE7B7),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ใบสมัครเปิดร้านค้าใหม่',
            style: GoogleFonts.krub(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'กรอกข้อมูลให้ครบถ้วนแล้วรอเจ้าหน้าที่/แอดมินอนุมัติเพื่อเริ่มขายสินค้าบนแพลตฟอร์ม',
            style: GoogleFonts.krub(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApprovalView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFFDE68A)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 44,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'ส่งใบสมัครเรียบร้อยแล้ว',
                style: GoogleFonts.krub(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'ร้าน “${controller.myShop.value?.name ?? ''}” อยู่ในระหว่างการตรวจสอบและอนุมัติจากแอดมิน',
                textAlign: TextAlign.center,
                style: GoogleFonts.krub(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'เมื่อได้รับอนุมัติแล้ว คุณจะสามารถเข้าถึงเมนูจัดการร้านค้า สินค้า และคำสั่งซื้อได้ทันที',
                textAlign: TextAlign.center,
                style: GoogleFonts.krub(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRejectedBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECDD3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE11D48)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'ใบสมัครยังไม่ได้รับอนุมัติ โปรดตรวจสอบและแก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่เพื่อพิจารณาอีกครั้ง',
              style: GoogleFonts.krub(
                fontSize: 13,
                color: const Color(0xFFBE123C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF059669), size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.krub(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildGeneralInfoSection() {
    return _buildCardContainer(
      title: 'ข้อมูลร้านค้าทั่วไป',
      icon: Icons.storefront_rounded,
      children: [
        AppTextField(
          labelText: 'ชื่อร้านค้า *',
          hintText: 'ระบุชื่อร้านค้าของคุณ',
          controller: controller.shopNameController,
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'กรุณากรอกชื่อร้านค้า' : null,
        ),
        const SizedBox(height: 14),
        Obx(() {
          final uniqueMap = <String, String>{};
          for (final c in controller.categories) {
            if (c.id.isNotEmpty) uniqueMap[c.id] = c.name;
          }
          final selectedVal = controller.selectedCategoryId.value;
          final validValue = (selectedVal != null && uniqueMap.containsKey(selectedVal)) ? selectedVal : null;

          return DropdownButtonFormField<String>(
            value: validValue,
            decoration: _inputDecoration('หมวดหมู่ร้านค้า *'),
            items: uniqueMap.entries.map((e) {
              return DropdownMenuItem<String>(
                value: e.key,
                child: Text(e.value, style: GoogleFonts.krub()),
              );
            }).toList(),
            onChanged: (val) => controller.selectedCategoryId.value = val,
            validator: (v) => v == null ? 'กรุณาเลือกหมวดหมู่' : null,
          );
        }),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'เบอร์โทรศัพท์',
                hintText: '0812345678',
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'อีเมล',
                hintText: 'shop@example.com',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'เวลาเปิดร้าน',
                hintText: '08:00',
                controller: controller.openingTimeController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'เวลาปิดร้าน',
                hintText: '18:00',
                controller: controller.closingTimeController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppTextField(
          labelText: 'รายละเอียดร้านค้า',
          hintText: 'อธิบายเกี่ยวกับสินค้า บริการ หรือจุดเด่นของร้าน',
          controller: controller.descriptionController,
        ),
        const SizedBox(height: 14),
        AppTextField(
          labelText: 'URL รูปภาพปกร้านค้า',
          hintText: 'https://example.com/shop-cover.jpg',
          controller: controller.coverImageUrlController,
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder(
          valueListenable: controller.coverImageUrlController,
          builder: (context, value, _) {
            if (value.text.trim().isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              height: 160,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  value.text.trim(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      'ไม่สามารถโหลดรูปภาพปกร้านค้าจาก URL นี้ได้',
                      style: GoogleFonts.krub(color: Colors.red.shade700, fontSize: 12),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return _buildCardContainer(
      title: 'ที่ตั้งและพื้นที่บริการ',
      icon: Icons.location_on_rounded,
      children: [
        Obx(() {
          final uniqueDistricts = <String, String>{};
          for (final d in controller.districts) {
            if (d.id.isNotEmpty) uniqueDistricts[d.id] = d.name;
          }
          final selectedVal = controller.selectedDistrictId.value;
          final validValue = (selectedVal != null && uniqueDistricts.containsKey(selectedVal)) ? selectedVal : null;

          return DropdownButtonFormField<String>(
            value: validValue,
            decoration: _inputDecoration('อำเภอ *'),
            items: uniqueDistricts.entries.map((e) {
              return DropdownMenuItem<String>(
                value: e.key,
                child: Text(e.value, style: GoogleFonts.krub()),
              );
            }).toList(),
            onChanged: (val) => controller.onDistrictChanged(val),
            validator: (v) => v == null ? 'กรุณาเลือกอำเภอ' : null,
          );
        }),
        const SizedBox(height: 14),
        Obx(() {
          final uniqueSubDistricts = <String, String>{};
          for (final sd in controller.subDistricts) {
            if (sd.id.isNotEmpty) uniqueSubDistricts[sd.id] = sd.name;
          }
          final selectedVal = controller.selectedSubDistrictId.value;
          final validValue = (selectedVal != null && uniqueSubDistricts.containsKey(selectedVal)) ? selectedVal : null;

          return DropdownButtonFormField<String>(
            value: validValue,
            decoration: _inputDecoration('ตำบล *'),
            items: uniqueSubDistricts.entries.map((e) {
              return DropdownMenuItem<String>(
                value: e.key,
                child: Text(e.value, style: GoogleFonts.krub()),
              );
            }).toList(),
            onChanged: (val) => controller.selectedSubDistrictId.value = val,
            validator: (v) => v == null ? 'กรุณาเลือกตำบล' : null,
          );
        }),
        const SizedBox(height: 14),
        AppTextField(
          labelText: 'ที่อยู่รายละเอียด',
          hintText: 'บ้านเลขที่ ถนน ซอย',
          controller: controller.addressController,
        ),
      ],
    );
  }

  Widget _buildBankSection() {
    return _buildCardContainer(
      title: 'ข้อมูลบัญชีธนาคารสำหรับรับเงิน',
      icon: Icons.account_balance_rounded,
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'ชื่อธนาคาร',
                hintText: 'เช่น กสิกรไทย, ไทยพาณิชย์',
                controller: controller.bankNameController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'ชื่อบัญชีธนาคาร',
                hintText: 'นาย สมชาย ใจดี',
                controller: controller.bankAccountNameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                labelText: 'เลขที่บัญชี',
                hintText: '123-4-56789-0',
                controller: controller.bankAccountNumberController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                labelText: 'เบอร์พร้อมเพย์ (ถ้ามี)',
                hintText: '0812345678',
                controller: controller.promptPayController,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isEdit = controller.myShop.value?.status == 'Rejected';
      return AppButton(
        text: isEdit ? 'แก้ไขและส่งใบสมัครอีกครั้ง' : 'ส่งใบสมัครเปิดร้านค้า',
        isLoading: controller.isSaving.value,
        onPressed: () => controller.submitApplication(),
      );
    });
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.krub(
        color: const Color(0xFF475569),
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF059669), width: 1.8),
      ),
    );
  }
}
