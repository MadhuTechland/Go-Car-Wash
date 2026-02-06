import 'dart:io';
import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/models/daily_report_model.dart';
import 'package:handyman_provider_flutter/services/daily_report_service.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class DailyReportScreen extends StatefulWidget {
  final String bookingId;
  final String serviceId;
  final String servicePlanId;

  const DailyReportScreen({
    Key? key,
    required this.bookingId,
    required this.serviceId,
    required this.servicePlanId,
  }) : super(key: key);

  @override
  State<DailyReportScreen> createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  final TextEditingController descriptionController = TextEditingController();
  File? selectedImage;

  /// Check if the start date is in the future (after today)
  bool _isStartDateInFuture(String startDateStr) {
    if (startDateStr.isEmpty) return false;
    try {
      final startDate = DateTime.parse(startDateStr);
      final today = DateTime.now();
      final todayDateOnly = DateTime(today.year, today.month, today.day);
      final startDateOnly = DateTime(startDate.year, startDate.month, startDate.day);
      return startDateOnly.isAfter(todayDateOnly);
    } catch (e) {
      return false;
    }
  }

  /// Format the start date for display
  String _formatStartDate(String startDateStr) {
    if (startDateStr.isEmpty) return '';
    try {
      final startDate = DateTime.parse(startDateStr);
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${months[startDate.month - 1]} ${startDate.day}, ${startDate.year}';
    } catch (e) {
      return startDateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          DailyReportController()..fetchDailyReports(widget.bookingId),
      child: Consumer<DailyReportController>(
        builder: (context, controller, _) {
          return AppScaffold(
            appBarTitle: 'Daily Wash Reports',
            body: controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          /// 🌟 Summary Card
                          Card(
                            color: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.calendar_today_rounded,
                                                color: Colors.blueAccent,
                                                size: 22),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Wash Plan Details',
                                                style: boldTextStyle(
                                                    size: 18,
                                                    color: Colors.blueAccent),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        flex: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.green.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            controller.remainingText,
                                            style: boldTextStyle(
                                                color: Colors.greenAccent,
                                                size: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoTile(
                                          'Start',
                                          controller.startDate,
                                          Icons.play_circle_fill),
                                      _buildInfoTile('End', controller.endDate,
                                          Icons.flag_circle_rounded),
                                    ],
                                  ),
                                  const Divider(
                                      color: Colors.white24, height: 28),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildInfoTile(
                                          'Days Passed',
                                          '${controller.daysPassed}',
                                          Icons.timelapse_rounded),
                                      _buildInfoTile(
                                          'Remaining',
                                          '${controller.daysRemaining}',
                                          Icons.hourglass_bottom_rounded),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// 📅 Check if booking starts in the future
                          if (_isStartDateInFuture(controller.startDate))
                            Card(
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.only(top: 0, bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.schedule_rounded,
                                        color: Colors.amber,
                                        size: 48,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Washing Service Not Started Yet',
                                      style: boldTextStyle(
                                          size: 18, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Your daily wash service will start from',
                                      style: secondaryTextStyle(
                                          size: 14, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.amber.withValues(alpha: 0.5)),
                                      ),
                                      child: Text(
                                        _formatStartDate(controller.startDate),
                                        style: boldTextStyle(
                                            size: 16, color: Colors.amber),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'You will be able to submit wash reports once the service begins.',
                                      style: secondaryTextStyle(
                                          size: 12, color: Colors.grey[500]),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          /// 📸 Upload Card (Only if pending and start date has passed)
                          else if (controller.todayStatus
                              .toLowerCase()
                              .contains('pending'))
                            Card(
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.only(top: 0, bottom: 16),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.upload_rounded,
                                            color: Colors.blueAccent, size: 22),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Submit Today's Report",
                                          style: boldTextStyle(
                                              size: 18,
                                              color: Colors.blueAccent),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    AppTextField(
                                      controller: descriptionController,
                                      textFieldType: TextFieldType.MULTILINE,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Enter a short description (optional)',
                                        hintStyle: secondaryTextStyle(
                                            color: Colors.grey[500]),
                                        filled: true,
                                        fillColor: Colors.grey[850],
                                        prefixIcon: const Icon(
                                            Icons.edit_note_rounded,
                                            color: Colors.white70),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Colors.grey[700]!),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                      minLines: 3,
                                      maxLines: 5,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppButton(
                                            text: selectedImage == null
                                                ? 'Take Photo'
                                                : 'Retake Photo',
                                            color: Colors.blueAccent,
                                            textColor: Colors.white,
                                            elevation: 2,
                                            onTap: () async {
                                              final picker = ImagePicker();
                                              final picked =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              if (picked != null) {
                                                setState(() => selectedImage =
                                                    File(picked.path));
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (selectedImage != null) ...[
                                      const SizedBox(height: 14),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          selectedImage!,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AppButton(
                                        text: 'Submit Report',
                                        color: Colors.greenAccent[700],
                                        textColor: Colors.white,
                                        elevation: 3,
                                        onTap: () async {
                                          if (selectedImage == null) {
                                            toast(
                                                'Please take a photo before submitting');
                                            return;
                                          }
                                          await controller.submitTodayReport(
                                            bookingId: widget.bookingId,
                                            serviceId: widget.serviceId,
                                            servicePlanId: widget.servicePlanId,
                                            date: DateTime.now()
                                                .toIso8601String(),
                                            description:
                                                descriptionController.text,
                                            imageFile: selectedImage,
                                          );
                                          setState(() {
                                            descriptionController.clear();
                                            selectedImage = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          /// 🗓️ Internal Cleaning Schedule
                          if (controller.internalCleaningSchedule != null)
                            _buildInternalCleaningScheduleWidget(
                                controller.internalCleaningSchedule!),

                          /// 🧾 Reports List
                          if (controller.reports.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(Icons.history_rounded,
                                    color: Colors.blueAccent, size: 22),
                                const SizedBox(width: 8),
                                Text(
                                  'Wash Reports',
                                  style: boldTextStyle(
                                      size: 18, color: Colors.blueAccent),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          ...controller.reports.map((report) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Date: ${report.date}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: report.status == 1
                                                ? Colors.green.withOpacity(0.2)
                                                : Colors.orange.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            report.status == 1
                                                ? 'Completed'
                                                : 'Pending',
                                            style: boldTextStyle(
                                              size: 12,
                                              color: report.status == 1
                                                  ? Colors.green
                                                  : Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Description: ${report.description.isNotEmpty ? report.description : 'No description'}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87),
                                    ),
                                    // Show user complaint if exists
                                    if (report.userMessage != null &&
                                        report.userMessage!.isNotEmpty) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color:
                                                  Colors.red.withOpacity(0.3)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.feedback_rounded,
                                                    color: Colors.red[700],
                                                    size: 18),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'Customer Complaint',
                                                  style: boldTextStyle(
                                                      size: 14,
                                                      color: Colors.red[700]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              report.userMessage!,
                                              style: secondaryTextStyle(
                                                  size: 13,
                                                  color: Colors.red[900]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    if (report.imageUrl.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          report.imageUrl,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, _, __) =>
                                              const Icon(Icons.broken_image,
                                                  size: 60),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),

                        ],
                      ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent, size: 18),
              const SizedBox(width: 6),
              Text(title,
                  style: secondaryTextStyle(size: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: boldTextStyle(size: 14, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInternalCleaningScheduleWidget(
      InternalCleaningSchedule schedule) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: Colors.tealAccent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Internal Cleaning Schedule',
                        style:
                            boldTextStyle(size: 18, color: Colors.tealAccent),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${schedule.totalCleanings} cleanings over ${schedule.totalMonths} months',
                        style:
                            secondaryTextStyle(size: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Summary Stats
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    '${schedule.cleaningsPerMonth}',
                    'Per Month',
                    Icons.calendar_month_rounded,
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey[700],
                  ),
                  _buildStatItem(
                    '${schedule.totalMonths}',
                    'Months',
                    Icons.date_range_rounded,
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey[700],
                  ),
                  _buildStatItem(
                    '${schedule.totalCleanings}',
                    'Total',
                    Icons.cleaning_services_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Monthly Schedule
            ...schedule.monthlySchedule.map((month) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.tealAccent.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Month Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.tealAccent.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            month.monthName,
                            style: boldTextStyle(
                                size: 16, color: Colors.tealAccent),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.tealAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${month.cleanings.length} cleanings',
                              style: secondaryTextStyle(
                                  size: 11, color: Colors.tealAccent),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Cleaning Dates
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: month.cleanings.map((cleaning) {
                          bool isPast = DateTime.tryParse(cleaning.date)
                                  ?.isBefore(DateTime.now()) ??
                              false;
                          bool isToday = cleaning.date ==
                              DateTime.now()
                                  .toString()
                                  .split(' ')[0];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? Colors.tealAccent.withValues(alpha: 0.15)
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                              border: isToday
                                  ? Border.all(color: Colors.tealAccent)
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isPast
                                        ? Colors.green.withValues(alpha: 0.2)
                                        : isToday
                                            ? Colors.tealAccent
                                                .withValues(alpha: 0.2)
                                            : Colors.grey[700],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    isPast
                                        ? Icons.check_circle_rounded
                                        : isToday
                                            ? Icons.today_rounded
                                            : Icons.schedule_rounded,
                                    size: 16,
                                    color: isPast
                                        ? Colors.green
                                        : isToday
                                            ? Colors.tealAccent
                                            : Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cleaning.formatted,
                                        style: boldTextStyle(
                                          size: 13,
                                          color: isToday
                                              ? Colors.tealAccent
                                              : Colors.white,
                                        ),
                                      ),
                                      if (isToday)
                                        Text(
                                          'Today',
                                          style: secondaryTextStyle(
                                              size: 11,
                                              color: Colors.tealAccent),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isPast)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Done',
                                      style: boldTextStyle(
                                          size: 10, color: Colors.green),
                                    ),
                                  )
                                else if (isToday)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.tealAccent
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Today',
                                      style: boldTextStyle(
                                          size: 10, color: Colors.tealAccent),
                                    ),
                                  )
                                else
                                  Text(
                                    'Upcoming',
                                    style: secondaryTextStyle(
                                        size: 11, color: Colors.grey),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: boldTextStyle(size: 18, color: Colors.white),
        ),
        Text(
          label,
          style: secondaryTextStyle(size: 11, color: Colors.grey),
        ),
      ],
    );
  }
}
