import '../../orders/models/order_model.dart';

class AdminPendingSlipGroup {
  final String slipImageUrl;
  final String? slipUploadedAt;
  final double totalGroupAmount;
  final String? buyerName;
  final String? buyerPhone;
  final List<OrderModel> orders;

  AdminPendingSlipGroup({
    required this.slipImageUrl,
    this.slipUploadedAt,
    required this.totalGroupAmount,
    this.buyerName,
    this.buyerPhone,
    required this.orders,
  });

  factory AdminPendingSlipGroup.fromJson(Map<String, dynamic> json) {
    return AdminPendingSlipGroup(
      slipImageUrl: json['slipImageUrl'] as String? ?? '',
      slipUploadedAt: json['slipUploadedAt'] as String?,
      totalGroupAmount: (json['totalGroupAmount'] as num?)?.toDouble() ?? 0.0,
      buyerName: json['buyerName'] as String?,
      buyerPhone: json['buyerPhone'] as String?,
      orders: (json['orders'] as List<dynamic>?)
              ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class VerifySlipPayload {
  final List<String> orderIds;
  final String action; // 'Approve' | 'Reject'

  VerifySlipPayload({
    required this.orderIds,
    required this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderIds': orderIds,
      'action': action,
    };
  }
}
