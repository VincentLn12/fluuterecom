import 'package:flutter/material.dart';

import '../models/room_model.dart';

class RoomDropdown extends StatelessWidget {
  final int? value;
  final List<RoomModel> rooms;
  final ValueChanged<int?> onChanged;
  final String label;

  const RoomDropdown({
    super.key,
    required this.value,
    required this.rooms,
    required this.onChanged,
    this.label = 'เลือกห้อง',
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: rooms
          .map(
            (room) => DropdownMenuItem<int>(
              value: room.id,
              child: Text('ห้อง ${room.roomNumber}'),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (selected) => selected == null ? 'กรุณาเลือกห้อง' : null,
    );
  }
}
