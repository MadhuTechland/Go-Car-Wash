class DailyReportModel {
  final int id;
  final String date;
  final int status;
  final String description;
  final String imageUrl;

  DailyReportModel({
    required this.id,
    required this.date,
    required this.status,
    required this.description,
    required this.imageUrl,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    return DailyReportModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      date: json['date'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      description: json['description'] ?? '',
      imageUrl: (json['image_url'] ?? '')
          .toString()
          .replaceAll('\\', '')
          .replaceAll(RegExp(r'\s+'), '')
          .trim(),
    );
  }
}

class DailyReportResponse {
  final String startDate;
  final String endDate;
  final int daysPassed;
  final int daysRemaining;
  final String remainingText;
  final String todayStatus; // 👈 add this line
  final List<DailyReportModel> reports;

  DailyReportResponse({
    required this.startDate,
    required this.endDate,
    required this.daysPassed,
    required this.daysRemaining,
    required this.remainingText,
    required this.todayStatus, // 👈 add this line
    required this.reports,
  });

  factory DailyReportResponse.fromJson(Map<String, dynamic> json) {
    final List reports = json['reports'] ?? [];

    return DailyReportResponse(
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      daysPassed: int.tryParse(json['days_passed'].toString()) ?? 0,
      daysRemaining: int.tryParse(json['days_remaining'].toString()) ?? 0,
      remainingText: json['remaining_text'] ?? '',
      todayStatus: json['today_status'] ?? '', // 👈 parse here
      reports: reports.map((e) => DailyReportModel.fromJson(e)).toList(),
    );
  }
}
