import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingInnerDetailsScreen extends StatelessWidget {
  const BookingInnerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),

      /// ✅ Using the shared appBarWidget
      appBar: appBarWidget(
        'Pending',
        color: primaryColor,
        textColor: Colors.white,
        elevation: 0,
        systemUiOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Check status action
            },
            child: const Text(
              'Check Status',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking ID Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Booking ID',
                    style: TextStyle(color: Colors.white54, fontSize: 16)),
                Text('#123',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),

            // Booking Details Card
            Card(
              color: context.cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FULL BODY WASH',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow('Date', '26 Jan, 2023'),
                          _buildInfoRow('Time', '4:00 PM'),
                          _buildInfoRow('Type', 'Butler'),
                          _buildInfoRow('Location type', 'At home'),
                          _buildInfoRow('Payment', 'Basic plan ₹299'),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://5.imimg.com/data5/SELLER/Default/2021/3/JE/SD/QI/39713083/car-washing-services-500x500.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Addons',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAddonCard(
                'AC Vent Cleaning',
                '₹109.00',
                'https://c.ndtvimg.com/2022-05/kkhimbb_car_625x300_10_May_22.jpg',
                context),
            _buildAddonCard(
                'Leather Seat Conditioning',
                '₹109.00',
                'https://c.ndtvimg.com/2022-05/kkhimbb_car_625x300_10_May_22.jpg',
                context),

            const SizedBox(height: 24),
            const Text(
              'Preferences',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              color: context.cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Vehicle', 'Car'),
                    _buildInfoRow('Bike Name', 'Tata Motors'),
                    _buildInfoRow('Model', 'Tata Puncher'),
                    _buildInfoRow('Price', 'Basic Plan ₹99'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: context.cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Vehicle', 'Bike'),
                    _buildInfoRow('Bike Series', 'Splendor'),
                    _buildInfoRow('Model', 'Hero Splendor Plus'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Cancel Booking',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Customer Info',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              color: context.cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Leslie Alexander',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  _buildIconTextRow(
                                      Icons.phone, '(406) 555-0120'),
                                  _buildIconTextRow(Icons.location_on,
                                      '2972 W 47th Ave, Kent, Washington 98042'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  15, vertical: 13),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 16, 
                              ),
                              const SizedBox(
                                  width: 6), 
                              const Text(
                                'Call',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      ])),
            ),

            const SizedBox(height: 24),
            const Text(
              'Price Detail',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              color: context.cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildPriceRow('Preference', '₹100'),
                    _buildPriceRow('Addons', '₹200'),
                    _buildPriceRow('Price', '₹250'),
                    const Divider(color: Colors.white12, height: 24),
                    _buildPriceRow('Sub Total', '₹550', isBold: true),
                    _buildPriceRow('Taxes', '₹33.66', isRed: true),
                    const Divider(color: Colors.white12, height: 24),
                    _buildPriceRow('Total Amount', '₹583.66', isTotal: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- helper widgets ---
  static Widget _buildInfoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Text('$label:',
                style: const TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(width: 8),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      );

  static Widget _buildAddonCard(
          String title, String price, String imageUrl, BuildContext context) =>
      Card(
        color: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imageUrl,
                width: 50, height: 50, fit: BoxFit.cover),
          ),
          title: Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(price,
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.check_box, color: primaryColor),
        ),
      );

  static Widget _buildIconTextRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text,
                  style: const TextStyle(color: Colors.white54, fontSize: 14)),
            ),
          ],
        ),
      );

  static Widget _buildPriceRow(String label, String value,
      {bool isBold = false, bool isRed = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                color: isTotal ? Colors.white : Colors.white54,
                fontSize: 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              )),
          Text(value,
              style: TextStyle(
                color: isRed
                    ? Colors.red
                    : (isTotal ? primaryColor : Colors.white),
                fontSize: 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              )),
        ],
      ),
    );
  }
}
