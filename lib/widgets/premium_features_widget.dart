import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

class PremiumFeaturesWidget extends StatelessWidget {
  const PremiumFeaturesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        BenifitWidget(
          text: 'Unlimited chat messages',
          iconData: Icons.all_inclusive,
        ),
        BenifitWidget(
          text: 'Faster reply',
          iconData: Icons.bolt,
        ),
        BenifitWidget(
          text: 'More detailed answers',
          iconData: Icons.sms,
        ),
        BenifitWidget(
          text: 'Chat history',
          iconData: Icons.history,
        ),
      ],
    );
  }
}

class BenifitWidget extends StatelessWidget {
  final text;
  final iconData;
  const BenifitWidget({
    super.key,
    required this.text,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.greenAccent,
          ),
          SizedBox(width: 12),
          TextWidget(
            label: text,
            color: Colors.white,
            fontSize: 15,
          )
        ],
      ),
    );
  }
}
