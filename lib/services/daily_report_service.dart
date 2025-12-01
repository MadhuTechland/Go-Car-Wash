import 'dart:io';

import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/models/daily_report_model.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';

class DailyReportController extends ChangeNotifier {
  List<DailyReportModel> reports = [];
  bool isLoading = false;

  // Summary data
  String startDate = '';
  String endDate = '';
  int daysPassed = 0;
  int daysRemaining = 0;
  String remainingText = '';
  String todayStatus = '';

  Future<void> fetchDailyReports(String bookingId) async {
    try {
      isLoading = true;
      notifyListeners();

      final reportResponse = await getDailyReportsAPI(bookingId: bookingId);

      startDate = reportResponse.startDate;
      endDate = reportResponse.endDate;
      daysPassed = reportResponse.daysPassed;
      daysRemaining = reportResponse.daysRemaining;
      remainingText = reportResponse.remainingText;
      reports = reportResponse.reports;
      todayStatus = reportResponse.todayStatus;
    } catch (e) {
      debugPrint('Error fetching reports: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitTodayReport({
    required String bookingId,
    required String serviceId,
    required String servicePlanId,
    required String date,
    String? description,
    File? imageFile,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await submitDailyReportAPI(
        bookingId: bookingId,
        serviceId: serviceId,
        servicePlanId: servicePlanId,
        date: date,
        description: description,
        imageFile: imageFile,
      );

      toast('Report submitted successfully');
      await fetchDailyReports(bookingId);
    } catch (e) {
      toast('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
