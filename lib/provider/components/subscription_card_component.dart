

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/configs.dart';

class SubscriptionCardComponent extends StatefulWidget {

  @override
  SubscriptionCardComponentState createState() => SubscriptionCardComponentState();

}

class SubscriptionCardComponentState extends State<SubscriptionCardComponent>{
  Widget build(BuildContext context) {
       return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(8),
        backgroundColor: context.cardColor,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichTextWidget(
                textAlign: TextAlign.center,
                list: [
                  TextSpan(
                      text: 'Current Plan ',
                      style: secondaryTextStyle(size: 12)),
                ],
              ),
              Spacer(),
              RichTextWidget(
                textAlign: TextAlign.center,
                list: [
                  TextSpan(
                      text: 'Valid Till',
                      style: secondaryTextStyle(size: 12)),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichTextWidget(
                textAlign: TextAlign.center,
                list: [
                  TextSpan(
                      text: 'Free Plan',
                      style: secondaryTextStyle(size: 14, color: white)),
                ],
              ),
              Spacer(),
              RichTextWidget(
                textAlign: TextAlign.center,
                list: [
                  TextSpan(
                      text: 'February 9, 2025',
                      style: secondaryTextStyle(size: 14, color: primaryColor)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}