import '../models/room_model.dart';
import 'api_service.dart';

class RoomService {
  final ApiService apiService;

  RoomService({required this.apiService});

  Future<List<RoomModel>> getRooms() async {
    final response = await apiService.get('rooms') as List<dynamic>;
    return response.map((e) => RoomModel.fromJson(e)).toList();
  }

  Future<RoomModel> createRoom(RoomModel room) async {
    final response = await apiService.post('rooms', room.toJson());
    return RoomModel.fromJson(response);
  }

  Future<RoomModel> updateRoom(RoomModel room) async {
    final response = await apiService.put('rooms/${room.id}', room.toJson());
    return RoomModel.fromJson(response);
  }

  Future<RoomModel> patchRoom(int id, Map<String, dynamic> body) async {
    final response = await apiService.patch('rooms/$id', body);
    return RoomModel.fromJson(response);
  }

  Future<void> deleteRoom(int id) => apiService.delete('rooms/$id');
}
