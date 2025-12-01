import 'dart:io';
import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/base_scaffold_widget.dart';
import 'package:handyman_provider_flutter/services/daily_report_service.dart';
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

                          /// 📸 Upload Card (Only if pending)
                          if (controller.todayStatus
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

                          /// 🧾 Reports List
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
                                    Text('Date: ${report.date}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor)),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Description: ${report.description.isNotEmpty ? report.description : 'No description'}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
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
}
