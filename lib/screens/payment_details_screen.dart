import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:handyman_provider_flutter/provider/services/add_services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/app_widgets.dart';
import '../main.dart';
import '../models/static_data_model.dart';
import '../models/service_model.dart';
import '../provider/payment/components/flutter_wave_service_new.dart';
import '../provider/payment/components/paystack_service.dart';
import '../provider/payment/components/razorpay_service_new.dart';
import '../provider/payment/components/stripe_service_new.dart';
import '../provider/provider_dashboard_screen.dart';
import '../utils/app_configuration.dart';
import '../utils/configs.dart';
import '../utils/colors.dart';
import '../components/back_widget.dart';
import '../components/empty_error_state_widget.dart';
import '../components/price_widget.dart';
import '../networks/rest_apis.dart';
import '../utils/constant.dart';
import '../utils/model_keys.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final int? id;
  final String? price;
  final String? planName;
  final String? duration;
  final int? gst;
  final double? taxAmount;
  final double? totalAmount;

  const PaymentDetailsScreen(
      {super.key,
      this.id,
      this.price,
      this.planName,
      this.duration,
      this.gst,
      this.taxAmount,
      this.totalAmount});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  List<PaymentSetting> paymentList = [];
  PaymentSetting? selectedPaymentSetting;

  @override
  void initState() {
    super.initState();
    getPaymentMethods();
  }

  Future<void> getPaymentMethods() async {
    appStore.setLoading(true);

    await getPaymentGateways(requireCOD: false).then((paymentListData) {
      paymentList = paymentListData.validate();
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  num get totalAmount {
    num base =
        num.tryParse(widget.price!.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    num gst = (base * 0.15);
    return double.parse((base + gst).toStringAsFixed(2));
  }

  Future<void> handleAddSubscriptionDetails(String trans_Id) async {
    appStore.setLoading(true);

    final req = {
      AddSubscriptionDetailsKey.userId: appStore.userId.toString(),
      AddSubscriptionDetailsKey.subscriptionId: widget.id.toString(),
      AddSubscriptionDetailsKey.gstAmount: widget.gst.toString(),
      AddSubscriptionDetailsKey.paymentStatus: "success",
      AddSubscriptionDetailsKey.totalAmount: widget.totalAmount.toString(),
      AddSubscriptionDetailsKey.transactionId: trans_Id,
    };

    print('Request payload: $req');

    try {
      final response = await saveSubscriptionDetails(req);
      toast("Subscription saved successfully");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ProviderDashboardScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      print('Error saving subscription: $e');
      toast("Failed to save subscription details");
    } finally {
      appStore.setLoading(false);
    }
  }

  void handlePayment() {
    if (selectedPaymentSetting == null) {
      toast("Please select a payment method");
      return;
    }

    final selected = selectedPaymentSetting!;
    if (selected.type == PAYMENT_METHOD_STRIPE) {
      StripeServiceNew(
        paymentSetting: selected,
        totalAmount: widget.totalAmount!,
        onComplete: (p0) {
          toast("Stripe Paid: ${p0['transaction_id']}");
        },
      ).stripePay();
    } else if (selected.type == PAYMENT_METHOD_RAZOR) {
      RazorPayServiceNew(
        paymentSetting: selected,
        totalAmount: widget.totalAmount!,
        onComplete: (p0) {
          handleAddSubscriptionDetails(p0['paymentId']);
        },
      ).razorPayCheckout();
    } else if (selected.type == PAYMENT_METHOD_FLUTTER_WAVE) {
      FlutterWaveServiceNew().checkout(
        paymentSetting: selected,
        totalAmount: widget.totalAmount!,
        onComplete: (p0) {
          toast("Flutterwave Paid: ${p0['transaction_id']}");
        },
      );
    }
    //  else if (selected.type == PAYMENT_METHOD_PAYSTACK) {
    //   PayStackService()
    //       .init(
    //         context: context,
    //         currentPaymentMethod: selected,
    //         totalAmount: widget.totalAmount!,
    //         loderOnOFF: (p) => appStore.setLoading(p),
    //         bookingId: widget.id.validate(),
    //         onComplete: (res) {
    //           toast("Paystack Paid: ${res["transaction_id"]}");
    //         },
    //       )
    //       .then((_) => PayStackService().checkout());
    // }
    else {
      toast("Payment method not implemented: ${selected.type}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding = width * 0.05;
    double fontSize = width * 0.04;
    double titleSize = width * 0.045;

    return Scaffold(
      appBar: appBarWidget(
        'Payment Details',
        textColor: white,
        color: primaryColor,
        showBack: true,
        backWidget: BackWidget(),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Order Summary
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Summary', style: boldTextStyle(size: 18)),
                      10.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${widget.planName} (${widget.duration})',
                              style: primaryTextStyle(size: 14)),
                          Text('${widget.price}',
                              style: boldTextStyle(size: 14)),
                        ],
                      ),
                      6.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('GST (${widget.gst}%)',
                              style: primaryTextStyle(size: 14)),
                          Text(
                            '₹${widget.taxAmount}',
                            style: boldTextStyle(size: 14),
                          ),
                        ],
                      ),
                      Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount', style: boldTextStyle(size: 14)),
                          Text('₹${widget.totalAmount}',
                              style: boldTextStyle(size: 14 + 1)),
                        ],
                      ),
                    ],
                  ),
                ),
                20.height,

                /// Payment Methods
                Text('Choose Payment Method', style: boldTextStyle()),
                8.height,
                if (paymentList.isNotEmpty)
                  AnimatedListView(
                    itemCount: paymentList.length,
                    shrinkWrap: true,
                    listAnimationType: ListAnimationType.FadeIn,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      PaymentSetting paymentData = paymentList[index];
                      return RadioListTile<PaymentSetting>(
                        dense: true,
                        value: paymentData,
                        groupValue: selectedPaymentSetting,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (value) {
                          selectedPaymentSetting = value;
                          setState(() {});
                        },
                        title: Text(paymentData.title.validate(),
                            style: primaryTextStyle()),
                      );
                    },
                  )
                else
                  NoDataWidget(
                    title: 'No payment methods found',
                    imageWidget: EmptyStateWidget(),
                  ),
                const Spacer(),

                /// Pay Button
                SizedBox(
                  width: double.infinity,
                  height: width * 0.13,
                  child: ElevatedButton(
                    onPressed: handlePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Pay ₹${widget.totalAmount}',
                        style: boldTextStyle(color: white)),
                  ),
                ),
              ],
            ),
          ),
          Observer(
            builder: (_) {
              return appStore.isLoading
                  ? const PaymentProcessingDialog().center()
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class PaymentProcessingDialog extends StatelessWidget {
  const PaymentProcessingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.cardColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: IntrinsicHeight(
          child: Column(
            children: [
              CircularProgressIndicator(color: primaryColor),
              24.height,
              Text(
                'Processing your payment...',
                style: boldTextStyle(size: 16),
                textAlign: TextAlign.center,
              ),
              8.height,
              Text(
                'Please wait while we confirm your subscription.',
                style: secondaryTextStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
