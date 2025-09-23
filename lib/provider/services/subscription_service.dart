import 'dart:convert';
import 'package:handyman_provider_flutter/networks/network_utils.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:http/http.dart' as http;

import '../../models/subscription_model.dart';

class SubscriptionService {
  static const String baseUrl = '${BASE_URL}subscriptionsinfo';

  static Future<List<SubscriptionModel>> fetchPlans() async {
    final response = await http.get(Uri.parse(baseUrl), headers: buildHeaderTokens());
    print('------------->,${response.statusCode}');
    print('------------->,${response.body}');
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == true) {
        final List<dynamic> plans = jsonData['subscriptions'];
        return plans.map((e) => SubscriptionModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load plans');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
