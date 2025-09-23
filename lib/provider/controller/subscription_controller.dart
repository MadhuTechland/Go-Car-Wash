import 'package:get/get.dart';
import '../../models/subscription_model.dart';
import '../services/subscription_service.dart';

class SubscriptionController extends GetxController {
  var plans = <SubscriptionModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchPlans();
    super.onInit();
  }

 Future<void> fetchPlans() async {
    try {
      isLoading(true);
      final data = await SubscriptionService.fetchPlans();
      plans.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
