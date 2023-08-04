import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

import '../constants/constants.dart';

class ImageScanAnimationWidget extends StatelessWidget {
  const ImageScanAnimationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.maxFinite,
      color: ColorPallate.bgColor.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/icons/camera.gif',
                // fit: BoxFit.cover,
                height: 72,
              )),
          TextWidget(label: 'Scanning image')
        ],
      ),
    );
  }
}
