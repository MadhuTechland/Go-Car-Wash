// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:get/get.dart';
// import 'package:nb_utils/nb_utils.dart';

// import '../components/app_widgets.dart';
// import '../components/back_widget.dart';
// import '../main.dart';
// import '../provider/controller/get_subscription_controller.dart';
// import '../provider/controller/subscription_controller.dart';
// import '../utils/colors.dart';
// import '../utils/configs.dart';
// import 'payment_details_screen.dart';

// class PlanSelectionScreen extends StatefulWidget {
//   const PlanSelectionScreen({super.key});

//   @override
//   State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
// }

// class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
//   final SubscriptionController controller = Get.put(SubscriptionController());
//   String selectedPlan = 'Gold';
//   bool? isSubscribed;

//   @override
//   void initState() {
//     super.initState();
//     int id = appStore.userId;
//     fetchSubscriptionStatus(id.toString());
//     appStore.setLoading(true);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchPlans().whenComplete(() {
//         appStore.setLoading(false);
//       });
//     });
//   }

//   Future<void> fetchSubscriptionStatus(String id) async {
//     setState(() => isSubscribed = null);

//     try {
//       final response = await getSubscriptionStatus(id);
//       if (response['status'] == true) {
//         setState(() => isSubscribed = response['subscribe'] == true);
//       } else {
//         setState(() => isSubscribed = false);
//       }
//     } catch (e) {
//       log('Subscription check failed: $e');
//       setState(() => isSubscribed = false);
//     }
//   }

//   @override
//   void dispose() {
//     Get.delete<SubscriptionController>();
//     super.dispose();
//   }

//   @override
// Widget build(BuildContext context) {
//   double width = MediaQuery.of(context).size.width;
//   double padding = width * 0.05;
//   double fontSize = width * 0.04;
//   return Scaffold(
//     appBar: appBarWidget(
//       'Choose Your Plan',
//       textColor: white,
//       color: context.primaryColor,
//       backWidget: BackWidget(),
//       showBack: true,
//     ),
//     body: Stack(
//       children: [
//         Observer(builder: (_) {
//           if (isSubscribed == null) {
//             return SizedBox();
//           }

//           return SingleChildScrollView(
//             padding: EdgeInsets.all(padding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (isSubscribed == true) ...[
//                   32.height,
//                   Center(
//                     child: Column(
//                       children: [
//                         Icon(Icons.verified, color: Colors.green, size: 60),
//                         16.height,
//                         Text(
//                           'You already have an active subscription!',
//                           style: boldTextStyle(size: (fontSize + 2).toInt()),
//                           textAlign: TextAlign.center,
//                         ),
//                         12.height,
//                         Text(
//                           'You can continue enjoying all premium features of your current plan.',
//                           style: secondaryTextStyle(size: (fontSize).toInt()),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ] else ...[
//                   Center(
//                     child: Column(
//                       children: [
//                         Text("Select The Perfect Plan For Your Needs",
//                             style: TextStyle(
//                                 fontSize: fontSize - 2,
//                                 color: Colors.grey[600])),
//                         SizedBox(height: padding),
//                       ],
//                     ),
//                   ),
//                   ...controller.plans.map((plan) {
//                     print('this is data --------->, ${plan.price}');
//                     bool isSelected = selectedPlan == plan.planName;
//                     return Column(
//                       children: [
//                         PlanCard(
//                           id: plan.id,
//                           title: plan.planName.capitalizeFirstLetter(),
//                           price: '₹${plan.price}',
//                           gst: plan.tax,
//                           taxAmount: plan.tax_amount,
//                           totalAmount: plan.total_amount,
//                           yearly: '',
//                           duration: plan.duration,
//                           features: plan.subscriptionPoints,
//                           tagLine: plan.tag,
//                           selected: isSelected,
//                           isPopular: plan.planName.toLowerCase() == 'gold',
//                           buttonText: isSelected
//                               ? "Selected ${plan.planName.capitalizeFirstLetter()}"
//                               : "Select ${plan.planName.capitalizeFirstLetter()}",
//                           onTap: () {
//                             setState(() {
//                               selectedPlan = plan.planName;
//                             });
//                           },
//                         ),
//                         SizedBox(height: padding),
//                       ],
//                     );
//                   }).toList(),
//                 ]
//               ],
//             ),
//           );
//         }),
//         Observer(
//           builder: (_) => LoaderWidget().center().visible(appStore.isLoading),
//         )
//       ],
//     ),
//   );
// }

// }

// class PlanCard extends StatelessWidget {
//   final int id;
//   final String title;
//   final String price;
//   final int gst;
//   final double taxAmount;
//   final double totalAmount;
//   final String yearly;
//   final String duration;
//   final List<String> features;
//   final bool selected;
//   final bool isPopular;
//   final String tagLine;
//   final String buttonText;
//   final VoidCallback onTap;

//   const PlanCard({
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.gst,
//     required this.taxAmount,
//     required this.totalAmount,
//     required this.yearly,
//     required this.duration,
//     required this.features,
//     required this.selected,
//     this.isPopular = false,
//     required this.tagLine,
//     required this.buttonText,
//     required this.onTap,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double padding = width * 0.05;
//     double fontSize = width * 0.04;

//     return GestureDetector(
//       onTap: onTap,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(
//                 color: selected ? primaryColor : Colors.transparent,
//                 width: selected ? 2 : 1,
//               ),
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 4,
//                   spreadRadius: 1,
//                 )
//               ],
//             ),
//             padding: EdgeInsets.all(padding),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('${title}',
//                     style: TextStyle(
//                         fontSize: fontSize + 2, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 4),
//                 Text(
//                   tagLine,
//                   style: TextStyle(
//                       color: Colors.grey[600], fontSize: fontSize - 2),
//                 ),
//                 SizedBox(height: 8),
//                 Text('${price}/${duration}',
//                     style: TextStyle(
//                         color: Colors.orange[800],
//                         fontSize: fontSize,
//                         fontWeight: FontWeight.bold)),
//                 SizedBox(height: 12),
//                 ...features.map((f) => Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 2),
//                       child: Row(
//                         children: [
//                           Icon(Icons.check_circle,
//                               color: Colors.green, size: fontSize),
//                           SizedBox(width: 8),
//                           Expanded(
//                               child: Text(f,
//                                   style: TextStyle(fontSize: fontSize - 1))),
//                         ],
//                       ),
//                     )),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: selected ? primaryColor : Colors.grey,
//                     minimumSize: Size(double.infinity, width * 0.12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: selected ? () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => PaymentDetailsScreen(
//                                   id: id,
//                                   price: price,
//                                   planName: title,
//                                   duration: duration,
//                                   gst: gst,
//                                   taxAmount: taxAmount,
//                                   totalAmount: totalAmount,
//                                 )));
//                   } : null,
//                   child: Text(buttonText,
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: fontSize - 1)),
//                 ),
//               ],
//             ),
//           ),
//           if (isPopular)
//             Positioned(
//               top: -12,
//               left: 20,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: primaryColor,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text("Most Popular Plan",
//                     style: TextStyle(
//                         fontSize: fontSize - 3, fontWeight: FontWeight.bold)),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/app_widgets.dart';
import '../components/back_widget.dart';
import '../main.dart';
import '../provider/controller/get_subscription_controller.dart';
import '../provider/controller/subscription_controller.dart';
import '../utils/colors.dart';
import '../utils/configs.dart';
import 'payment_details_screen.dart';

class PlanSelectionScreen extends StatefulWidget {
  const PlanSelectionScreen({super.key});

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  final SubscriptionController controller = Get.put(SubscriptionController());
  String selectedPlan = 'Gold';
  bool? isSubscribed;

  @override
  void initState() {
    super.initState();
    int id = appStore.userId;
    fetchSubscriptionStatus(id.toString());
    appStore.setLoading(true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPlans().whenComplete(() {
        appStore.setLoading(false);
      });
    });
  }

  Future<void> fetchSubscriptionStatus(String id) async {
    setState(() => isSubscribed = null);

    try {
      final response = await getSubscriptionStatus(id);
      if (response['status'] == true) {
        setState(() => isSubscribed = response['subscribe'] == true);
      } else {
        setState(() => isSubscribed = false);
      }
    } catch (e) {
      log('Subscription check failed: $e');
      setState(() => isSubscribed = false);
    }
  }

  @override
  void dispose() {
    Get.delete<SubscriptionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width * 0.05;
    double fontSize = width * 0.04;
    print('yes im touch man ............!');
    return Scaffold(
      appBar: appBarWidget(
        'Subscription',
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        showBack: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value || isSubscribed == null) {
          return LoaderWidget().center();
        }

        return Column(children: [
          Expanded(
              child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSubscribed == true) ...[
                  32.height,
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.verified, color: Colors.green, size: 60),
                        16.height,
                        Text(
                          'You already have an active subscription!',
                          style: boldTextStyle(size: (fontSize + 2).toInt()),
                          textAlign: TextAlign.center,
                        ),
                        12.height,
                        Text(
                          'You can continue enjoying all premium features of your current plan.',
                          style: secondaryTextStyle(size: (fontSize).toInt()),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        Text('Choose Your Plan', style: TextStyle(fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.bold),),
                        Text("Select The Perfect Plan For Your Needs",
                            style: TextStyle(
                                fontSize: fontSize - 2,
                                color: Colors.grey[600])),
                        SizedBox(height: padding),
                      ],
                    ),
                  ),
                  ...controller.plans.map((plan) {
                    bool isSelected = selectedPlan == plan.planName;
                    print('I got the data ---------> ${plan.price}');
                    return Column(
                      children: [
                        PlanCard(
                          id: plan.id,
                          title: plan.planName.capitalizeFirstLetter(),
                          price: '₹${plan.price}',
                          gst: plan.tax,
                          taxAmount: plan.tax_amount,
                          totalAmount: plan.total_amount,
                          yearly: '',
                          duration: plan.duration,
                          features: plan.subscriptionPoints,
                          tagLine: plan.tag,
                          selected: isSelected,
                          isPopular: plan.planName.toLowerCase() == 'gold',
                          buttonText: isSelected
                              ? "Selected ${plan.planName.capitalizeFirstLetter()}"
                              : "Select ${plan.planName.capitalizeFirstLetter()}",
                          onTap: () {
                            setState(() {
                              selectedPlan = plan.planName;
                            });
                          },
                        ),
                        SizedBox(height: padding),
                      ],
                    );
                  }).toList(),
                ]
              ],
            ),
          ))
        ]);
      }),
    );
  }
}

class PlanCard extends StatelessWidget {
  final int id;
  final String title;
  final String price;
  final dynamic gst;
  final double taxAmount;
  final double totalAmount;
  final String yearly;
  final String duration;
  final List<String> features;
  final bool selected;
  final bool isPopular;
  final String tagLine;
  final String buttonText;
  final VoidCallback onTap;

  const PlanCard({
    required this.id,
    required this.title,
    required this.price,
    required this.gst,
    required this.taxAmount,
    required this.totalAmount,
    required this.yearly,
    required this.duration,
    required this.features,
    required this.selected,
    this.isPopular = false,
    required this.tagLine,
    required this.buttonText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width * 0.05;
    double fontSize = width * 0.04;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.cardColor,
              border: Border.all(
                color: selected ? primaryColor : Colors.transparent,
                width: selected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1,
                )
              ],
            ),
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${title}',
                    style: primaryTextStyle(size: 18)),
                SizedBox(height: 4),
                Text(
                  tagLine,
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: fontSize - 2),
                ),
                SizedBox(height: 8),
                Text('${price}/${duration}',
                    style: TextStyle(
                        color: Colors.orange[800],
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                ...features.map((f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: fontSize),
                          SizedBox(width: 8),
                          Expanded(
                              child: Text(f,
                                   style: primaryTextStyle(size: 14),))
                        ],
                      ),
                    )),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected ? primaryColor : Color(0xFFB0B0B0),
                    minimumSize: Size(double.infinity, width * 0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: selected
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentDetailsScreen(
                                        id: id,
                                        price: price,
                                        planName: title,
                                        duration: duration,
                                        gst: gst,
                                        taxAmount: taxAmount,
                                        totalAmount: totalAmount,
                                      )));
                        }
                      : null,
                  child: Text(buttonText,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: fontSize - 1)),
                ),
              ],
            ),
          ),
          if (isPopular)
            Positioned(
              top: -12,
              left: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("Most Popular Plan",
                    style: TextStyle(
                        fontSize: fontSize - 3, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
