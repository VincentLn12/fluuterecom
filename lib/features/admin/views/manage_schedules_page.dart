import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/admin_schedules_controller.dart';
import '../models/admin_schedule_model.dart';

class ManageSchedulesPage extends GetView<AdminSchedulesController> {
  const ManageSchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AdminSchedulesController>()) {
      Get.put(AdminSchedulesController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'ตารางกิจกรรม/ปฏิทิน (Schedule Management)',
          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => _showScheduleForm(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final schedules = controller.schedules;
        if (schedules.isEmpty) {
          return Center(
            child: Text('ไม่มีตารางกิจกรรมในระบบ', style: GoogleFonts.krub(color: AppColors.textSecondary)),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final sch = schedules[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          sch.title,
                          style: GoogleFonts.krub(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A86EF).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          sch.status,
                          style: GoogleFonts.krub(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF3A86EF)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'เริ่ม: ${sch.startDateTime}',
                          style: GoogleFonts.krub(fontSize: 12, color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (sch.address != null && sch.address!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            sch.address!,
                            style: GoogleFonts.krub(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                        onPressed: () => _showScheduleForm(context, schedule: sch),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error),
                        onPressed: () => controller.deleteSchedule(sch.scheduleId),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _showScheduleForm(BuildContext context, {AdminSchedule? schedule}) {
    final titleCtrl = TextEditingController(text: schedule?.title ?? '');
    final dateCtrl = TextEditingController(text: schedule?.startDateTime ?? DateTime.now().toIso8601String().substring(0, 10));
    final addressCtrl = TextEditingController(text: schedule?.address ?? '');
    final descCtrl = TextEditingController(text: schedule?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(schedule == null ? 'สร้างกิจกรรมใหม่' : 'แก้ไขกิจกรรม', style: GoogleFonts.krub(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'ชื่อกิจกรรม (Title)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateCtrl,
                decoration: const InputDecoration(labelText: 'วันที่เริ่ม (YYYY-MM-DD)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(labelText: 'สถานที่จัดงาน (Address)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'รายละเอียดกิจกรรม', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('ยกเลิก', style: GoogleFonts.krub(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              final data = ScheduleFormData(
                title: titleCtrl.text.trim(),
                startDateTime: dateCtrl.text.trim(),
                address: addressCtrl.text.trim(),
                description: descCtrl.text.trim(),
                status: 'Active',
              );
              await controller.saveSchedule(id: schedule?.scheduleId, data: data);
              Navigator.pop(context);
            },
            child: Text('บันทึก', style: GoogleFonts.krub(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
