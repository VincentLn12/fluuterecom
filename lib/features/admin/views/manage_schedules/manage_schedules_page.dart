import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../controllers/admin_schedules_controller.dart';
import '../../models/admin_schedule_model.dart';
import 'widgets/manage_schedule_form_dialog.dart';
import 'widgets/manage_schedules_list.dart';

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
        onPressed: () =>
            ManageScheduleFormDialog.show(context, controller: controller),
        child: const Icon(Icons.add),
      ),
      body: ManageSchedulesList(
        controller: controller,
        onEdit: (AdminSchedule schedule) => ManageScheduleFormDialog.show(
          context,
          controller: controller,
          schedule: schedule,
        ),
      ),
    );
  }
}
