import 'package:get/get.dart';
import '../models/content_model.dart';
import '../repositories/content_repository.dart';

class ContentDetailController extends GetxController {
  ContentDetailController({ContentRepository? repository})
      : _repository = repository ?? ContentRepository();

  final ContentRepository _repository;
  final content = Rxn<ContentModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ContentModel) {
      content.value = args;
    } else if (args is String) {
      loadContentById(args);
    } else if (Get.parameters['id'] != null) {
      loadContentById(Get.parameters['id']!);
    }
  }

  Future<void> loadContentById(String id) async {
    isLoading.value = true;
    try {
      final result = await _repository.fetchContentById(id);
      content.value = result;
    } finally {
      isLoading.value = false;
    }
  }
}
