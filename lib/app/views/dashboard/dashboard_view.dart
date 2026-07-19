import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_theme.dart';
import '../../controllers/dashboard_controller.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/summary_card.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget();
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchDashboard,
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchDashboard,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Beautiful Gradient Header
              SliverAppBar(
                expandedHeight: 125.0,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primary, Color(0xFF6366F1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          top: -10,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.08,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            20,
                            topInset + 4,
                            20,
                            12,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'สวัสดีผู้ดูแลระบบ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'ยินดีต้อนรับกลับสู่ระบบจัดการหอพัก',
                                      style: TextStyle(
                                        color: Color(0xFFE0E7FF),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),

              // Overview Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ภาพรวมของหอพัก',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'อัปเดตล่าสุดวันนี้',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Dashboard Statistics Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 4 : 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: isTablet ? 1.3 : 1.15,
                  ),
                  delegate: SliverChildListDelegate([
                    SummaryCard(
                      title: 'ห้องทั้งหมด',
                      value: '${controller.totalRooms}',
                      icon: Icons.apartment_rounded,
                      color: AppTheme.primary,
                    ),
                    SummaryCard(
                      title: 'ห้องว่าง',
                      value: '${controller.vacantRooms}',
                      icon: Icons.check_circle_outline_rounded,
                      color: AppTheme.success,
                    ),
                    SummaryCard(
                      title: 'ห้องมีผู้เช่า',
                      value: '${controller.occupiedRooms}',
                      icon: Icons.people_alt_rounded,
                      color: const Color(0xFF8B5CF6), // Royal Purple
                    ),
                    SummaryCard(
                      title: 'ห้องซ่อมบำรุง',
                      value: '${controller.maintenanceRooms}',
                      icon: Icons.build_circle_rounded,
                      color: AppTheme.warning,
                    ),
                    SummaryCard(
                      title: 'บิลค้างชำระ',
                      value: '${controller.pendingBills}',
                      icon: Icons.receipt_long_rounded,
                      color: AppTheme.danger,
                    ),
                    SummaryCard(
                      title: 'รายได้เดือนนี้',
                      value: CurrencyFormatter.format(controller.monthlyIncome),
                      icon: Icons.monetization_on_rounded,
                      color: AppTheme.success,
                    ),
                    SummaryCard(
                      title: 'แจ้งซ่อมค้าง',
                      value: '${controller.openRequests}',
                      icon: Icons.report_problem_rounded,
                      color: AppTheme.warning,
                    ),
                  ]),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      }),
    );
  }
}
