class DailyReportModel {
  final int id;
  final String date;
  final int status;
  final String description;
  final String? userMessage; // Customer complaint
  final String imageUrl;

  DailyReportModel({
    required this.id,
    required this.date,
    required this.status,
    required this.description,
    this.userMessage,
    required this.imageUrl,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    return DailyReportModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      date: json['date'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      description: json['description'] ?? '',
      userMessage: json['user_message'],
      imageUrl: (json['image_url'] ?? '')
          .toString()
          .replaceAll('\\', '')
          .replaceAll(RegExp(r'\s+'), '')
          .trim(),
    );
  }
}

/// Internal Cleaning Date Model
class CleaningDate {
  final String date;
  final String day;
  final String formatted;

  CleaningDate({
    required this.date,
    required this.day,
    required this.formatted,
  });

  factory CleaningDate.fromJson(Map<String, dynamic> json) {
    return CleaningDate(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      formatted: json['formatted'] ?? '',
    );
  }
}

/// Monthly Schedule Model
class MonthlySchedule {
  final int month;
  final String monthName;
  final String monthStart;
  final String monthEnd;
  final List<CleaningDate> cleanings;

  MonthlySchedule({
    required this.month,
    required this.monthName,
    required this.monthStart,
    required this.monthEnd,
    required this.cleanings,
  });

  factory MonthlySchedule.fromJson(Map<String, dynamic> json) {
    final List cleaningsList = json['cleanings'] ?? [];
    return MonthlySchedule(
      month: int.tryParse(json['month'].toString()) ?? 0,
      monthName: json['month_name'] ?? '',
      monthStart: json['month_start'] ?? '',
      monthEnd: json['month_end'] ?? '',
      cleanings: cleaningsList.map((e) => CleaningDate.fromJson(e)).toList(),
    );
  }
}

/// Internal Cleaning Schedule Model
class InternalCleaningSchedule {
  final int cleaningsPerMonth;
  final int totalMonths;
  final int totalCleanings;
  final List<MonthlySchedule> monthlySchedule;
  final List<CleaningDate> allDates;

  InternalCleaningSchedule({
    required this.cleaningsPerMonth,
    required this.totalMonths,
    required this.totalCleanings,
    required this.monthlySchedule,
    required this.allDates,
  });

  factory InternalCleaningSchedule.fromJson(Map<String, dynamic> json) {
    final List monthlyList = json['monthly_schedule'] ?? [];
    final List allDatesList = json['all_dates'] ?? [];
    return InternalCleaningSchedule(
      cleaningsPerMonth: int.tryParse(json['cleanings_per_month'].toString()) ?? 0,
      totalMonths: int.tryParse(json['total_months'].toString()) ?? 0,
      totalCleanings: int.tryParse(json['total_cleanings'].toString()) ?? 0,
      monthlySchedule: monthlyList.map((e) => MonthlySchedule.fromJson(e)).toList(),
      allDates: allDatesList.map((e) => CleaningDate.fromJson(e)).toList(),
    );
  }
}

class DailyReportResponse {
  final String startDate;
  final String endDate;
  final int daysPassed;
  final int daysRemaining;
  final String remainingText;
  final String todayStatus;
  final int washType;
  final int internalCleaning;
  final List<DailyReportModel> reports;
  final InternalCleaningSchedule? internalCleaningSchedule;

  DailyReportResponse({
    required this.startDate,
    required this.endDate,
    required this.daysPassed,
    required this.daysRemaining,
    required this.remainingText,
    required this.todayStatus,
    required this.washType,
    required this.internalCleaning,
    required this.reports,
    this.internalCleaningSchedule,
  });

  factory DailyReportResponse.fromJson(Map<String, dynamic> json) {
    final List reports = json['reports'] ?? [];

    return DailyReportResponse(
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      daysPassed: int.tryParse(json['days_passed'].toString()) ?? 0,
      daysRemaining: int.tryParse(json['days_remaining'].toString()) ?? 0,
      remainingText: json['remaining_text'] ?? '',
      todayStatus: json['today_status'] ?? '',
      washType: int.tryParse(json['wash_type'].toString()) ?? 0,
      internalCleaning: int.tryParse(json['internal_cleaning'].toString()) ?? 0,
      reports: reports.map((e) => DailyReportModel.fromJson(e)).toList(),
      internalCleaningSchedule: json['internal_cleaning_schedule'] != null
          ? InternalCleaningSchedule.fromJson(json['internal_cleaning_schedule'])
          : null,
    );
  }
}
