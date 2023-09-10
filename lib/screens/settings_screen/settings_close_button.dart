import 'package:flutter/material.dart';

class SettingsCloseButton extends StatelessWidget {
  const SettingsCloseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.cancel,
          color: Colors.white,
        ),
      ),
    );
  }
}
