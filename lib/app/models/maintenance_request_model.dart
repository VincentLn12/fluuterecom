import '../utils/json_parser.dart';

class MaintenanceRequestModel {
  final int? id;
  final int roomId;
  final String title;
  final String description;
  final String priority;
  final String status;
  final String createdAt;
  final String? completedAt;

  const MaintenanceRequestModel({
    this.id,
    required this.roomId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.completedAt,
  });

  factory MaintenanceRequestModel.fromJson(Map<String, dynamic> json) =>
      MaintenanceRequestModel(
        id: JsonParser.asInt(json['id']),
        roomId: JsonParser.asInt(json['roomId']) ?? 0,
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        priority: json['priority']?.toString() ?? 'medium',
        status: json['status']?.toString() ?? 'pending',
        createdAt: json['createdAt']?.toString() ?? '',
        completedAt: json['completedAt']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'roomId': roomId,
    'title': title,
    'description': description,
    'priority': priority,
    'status': status,
    'createdAt': createdAt,
    'completedAt': completedAt,
  };

  MaintenanceRequestModel copyWith({
    int? id,
    int? roomId,
    String? title,
    String? description,
    String? priority,
    String? status,
    String? createdAt,
    String? completedAt,
  }) {
    return MaintenanceRequestModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
