import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';
import 'package:lottie/lottie.dart';

class TaskCardSummaryWidget extends StatefulWidget {
  final VoidCallback? onPressed;
  const TaskCardSummaryWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<TaskCardSummaryWidget> createState() => _TaskCardSummaryWidgetState();
}

class _TaskCardSummaryWidgetState extends State<TaskCardSummaryWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 8, top: 8, bottom: 10),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 2, 71, 117),
            borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Summary',
              maxLines: 1,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Summarize text from photos',
              maxLines: 3,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            // SizedBox(height: 30),
            Container(
              // color: Colors.amber,
              height: 120,

              alignment: Alignment.bottomRight,
              child: Lottie.asset(
                'assets/animations/image_scan2.json',
                controller: _controller,
                onLoaded: (composition) {
                  // Configure the AnimationController with the duration of the
                  // Lottie file and start the animation.
                  _controller
                    ..duration = composition.duration
                    ..repeat();
                },
              ),
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.max,
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextWidget(
            //       label: '📷',
            //       fontSize: 50,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
