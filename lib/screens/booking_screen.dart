import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/screens/booking_inner_details_screen.dart';
import 'package:handyman_provider_flutter/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import '../booking_filter/booking_filter_screen.dart';
import '../utils/configs.dart';
import '../utils/images.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedTab = 0; // 0 = Instant Booking, 1 = Daily Bookings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // -------- Search + Sort Row ----------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'search for booking',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: context.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: IconButton(
                      icon: ic_filter.iconImage(color: white, size: 20),
                      onPressed: () async {
                        final bool? applied = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingFilterScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // -------- Tab Bar with Indicator ----------
            SizedBox(
              height: 45,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabButton('Instant Booking', 0),
                      _buildTabButton('Daily Bookings', 1),
                    ],
                  ),
                  // animated indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    left: selectedTab == 0
                        ? MediaQuery.of(context).size.width * 0.1
                        : MediaQuery.of(context).size.width * 0.55,
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 3,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),

            // -------- Tab Content ----------
            if (selectedTab == 0) ...[
              _buildBookingCard(),
              const SizedBox(height: 20),
              _buildBookingCard(isFullCard: true),
            ] else if (selectedTab == 1) ...[
              _buildBookingCard(isFullCard: true),
            ],

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ---------- Tab Button ----------
  Widget _buildTabButton(String text, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() => selectedTab = index);
      },
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  // ---------- Booking Card ----------
  Widget _buildBookingCard({bool isFullCard = false}) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => BookingInnerDetailsScreen()));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const Text(
                    '#458',
                    style: TextStyle(
                        color: Colors.white54, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'XUV 400',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '₹299 (5% Off)',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Your address', 'Elm Street, number 123.'),
              _buildInfoRow('Date & Time', '25 Apr, 2023 At 02:30 AM'),
              _buildInfoRow('Customer name', 'Alexander'),
              _buildInfoRow('Customer mobile number', '+917785775629'),
              _buildInfoRow('Plan', 'Basic Plan ₹299'),
              _buildInfoRow('Wash Type', 'Instant wash'),
              _buildInfoRow('Location Type', 'At home'),
              _buildInfoRow('Address', 'View more', isLink: true),
              if (isFullCard) ...[
                const SizedBox(height: 8),
                _buildInfoRow('Preferences', 'View more', isLink: true),
                _buildInfoRow('Payment status', 'Online', isOnline: true),
              ] else ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Accept',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Decline',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ));
  }

  Widget _buildInfoRow(String title, String value,
      {bool isLink = false, bool isOnline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: isLink
                  ? const Color(0xFF007AFF)
                  : (isOnline ? Colors.green : Colors.white),
              fontSize: 14,
              fontWeight: isLink ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
