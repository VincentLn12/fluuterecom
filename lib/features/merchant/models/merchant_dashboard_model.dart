class MerchantDashboardModel {
  final double totalRevenue;
  final double todayRevenue;
  final double monthRevenue;
  final int totalOrders;
  final int pendingSlipOrdersCount;
  final int pendingShipmentOrdersCount;
  final int completedOrdersCount;
  final int totalProducts;
  final int lowStockProductsCount;
  final int totalContents;
  final List<RecentOrderSummary> recentOrders;

  MerchantDashboardModel({
    required this.totalRevenue,
    required this.todayRevenue,
    required this.monthRevenue,
    required this.totalOrders,
    required this.pendingSlipOrdersCount,
    required this.pendingShipmentOrdersCount,
    required this.completedOrdersCount,
    required this.totalProducts,
    required this.lowStockProductsCount,
    required this.totalContents,
    required this.recentOrders,
  });

  factory MerchantDashboardModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] as Map<String, dynamic>? ?? {};
    final recentList = json['recentOrders'] as List? ?? [];

    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString()) ?? 0;
    }

    return MerchantDashboardModel(
      totalRevenue: parseDouble(summary['totalRevenue']),
      todayRevenue: parseDouble(summary['todayRevenue']),
      monthRevenue: parseDouble(summary['monthRevenue']),
      totalOrders: parseInt(summary['totalOrders']),
      pendingSlipOrdersCount: parseInt(summary['pendingSlipOrdersCount']),
      pendingShipmentOrdersCount: parseInt(summary['pendingShipmentOrdersCount']),
      completedOrdersCount: parseInt(summary['completedOrdersCount']),
      totalProducts: parseInt(summary['totalProducts']),
      lowStockProductsCount: parseInt(summary['lowStockProductsCount']),
      totalContents: parseInt(summary['totalContents']),
      recentOrders: recentList
          .map((e) => RecentOrderSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RecentOrderSummary {
  final String orderId;
  final String orderNumber;
  final String? receiverName;
  final double totalAmount;
  final String orderStatus;
  final String paymentStatus;
  final String createdAt;

  RecentOrderSummary({
    required this.orderId,
    required this.orderNumber,
    this.receiverName,
    required this.totalAmount,
    required this.orderStatus,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory RecentOrderSummary.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    return RecentOrderSummary(
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      receiverName: json['receiverName']?.toString(),
      totalAmount: parseDouble(json['totalAmount']),
      orderStatus: json['orderStatus']?.toString() ?? 'Pending',
      paymentStatus: json['paymentStatus']?.toString() ?? 'Pending',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
