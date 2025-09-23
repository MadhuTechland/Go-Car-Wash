import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/back_widget.dart';
import '../utils/configs.dart';
import 'subscription_screen.dart';

class TakeSubscriptionMessage extends StatefulWidget {
  final bool showAppBar;

  const TakeSubscriptionMessage({super.key, this.showAppBar = true});

  @override
  State<TakeSubscriptionMessage> createState() => _TakeSubscriptionMessageState();
}

class _TakeSubscriptionMessageState extends State<TakeSubscriptionMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? appBarWidget(
              'Subscription Required',
              color: context.primaryColor,
              textColor: white,
              backWidget: BackWidget(),
              elevation: 0,
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, color: primaryColor, size: 80),
            24.height,
            Text(
              'Access Restricted',
              style: boldTextStyle(size: 20),
              textAlign: TextAlign.center,
            ),
            16.height,
            Text(
              'This feature is available to subscribed users only. To unlock premium services, enhance your visibility, and connect with more customers, please choose a subscription plan.',
              style: primaryTextStyle(size: 16),
              textAlign: TextAlign.center,
            ),
            32.height,
            AppButton(
              text: 'Take Subscription',
              color: primaryColor,
              width: 200,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(8)),
              onTap: () {
                finish(context);
                PlanSelectionScreen().launch(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
