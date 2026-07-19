import '../models/bill_model.dart';
import 'api_service.dart';

class BillService {
  final ApiService apiService;

  BillService({required this.apiService});

  Future<List<BillModel>> getBills() async {
    final response = await apiService.get('bills') as List<dynamic>;
    return response.map((e) => BillModel.fromJson(e)).toList();
  }

  Future<BillModel> createBill(BillModel bill) async {
    final response = await apiService.post('bills', bill.toJson());
    return BillModel.fromJson(response);
  }

  Future<BillModel> updateBill(BillModel bill) async {
    final response = await apiService.put('bills/${bill.id}', bill.toJson());
    return BillModel.fromJson(response);
  }

  Future<BillModel> patchBill(int id, Map<String, dynamic> body) async {
    final response = await apiService.patch('bills/$id', body);
    return BillModel.fromJson(response);
  }

  Future<void> deleteBill(int id) => apiService.delete('bills/$id');
}
