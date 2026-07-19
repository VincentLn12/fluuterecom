import '../models/user_model.dart';
import 'api_service.dart';

class UserService {
  final ApiService apiService;

  UserService({required this.apiService});

  Future<List<UserModel>> getUsers() async {
    final response = await apiService.get('users') as List<dynamic>;
    return response.map((e) => UserModel.fromJson(e)).toList();
  }
}
