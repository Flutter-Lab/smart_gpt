import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsAndConditionMD extends StatelessWidget {
  const TermsAndConditionMD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: rootBundle.loadString('assets/docs/terms_and_conditions.md'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading Markdown file'));
          } else {
            return Column(
              children: [
                SizedBox(height: 24),
                Text('Terms and Conditions'),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.cancel_outlined)),
                  ],
                ),
                Flexible(child: Markdown(data: snapshot.data ?? '')),
              ],
            );
          }
        },
      ),
    );
  }
}
