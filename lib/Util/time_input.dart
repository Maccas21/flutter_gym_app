import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeInput extends StatelessWidget {
  final TextEditingController hoursController;
  final TextEditingController minsController;
  final TextEditingController secsController;
  final bool compact;

  const TimeInput({
    super.key,
    required this.hoursController,
    required this.minsController,
    required this.secsController,
    required this.compact,
  });

  // Checks for overflowing minutes and seconds if over 59
  // Over 99 hours wraps back to 1
  void overflowChecks() {
    if (secsController.text != '' && int.parse(secsController.text) > 59) {
      secsController.text = (int.parse(secsController.text) - 60).toString();
      minsController.text = (int.parse(minsController.text) + 1).toString();
    }
    if (minsController.text != '' && int.parse(minsController.text) > 59) {
      minsController.text = (int.parse(minsController.text) - 60).toString();

      if (hoursController.text != '' && int.parse(hoursController.text) < 99) {
        hoursController.text = (int.parse(hoursController.text) + 1).toString();
      } else {
        hoursController.text = '1';
      }
    }
  }

  void onTap(TextEditingController controller) {
    if (controller.text == '0') {
      controller.text = '';
    }
  }

  void onOffTap(TextEditingController controller) {
    if (controller.text == '') {
      controller.text = '0';
    }

    // closes keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    overflowChecks();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          compact ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(compact ? 'H' : 'Hours'),
            SizedBox(
              width: 50,
              child: TextField(
                controller: hoursController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: const InputDecoration.collapsed(
                  hintText: '',
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                showCursor: true,
                onSubmitted: (value) {
                  onOffTap(hoursController);
                },
                onTapOutside: (event) {
                  onOffTap(hoursController);
                },
                onTap: () {
                  onTap(hoursController);
                },
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(compact ? 'M' : 'Minutes'),
            SizedBox(
              width: 50,
              child: TextField(
                controller: minsController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: const InputDecoration.collapsed(
                  hintText: '',
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                showCursor: true,
                onSubmitted: (value) {
                  onOffTap(minsController);
                },
                onTapOutside: (event) {
                  onOffTap(minsController);
                },
                onTap: () {
                  onTap(minsController);
                },
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(compact ? 'S' : 'Seconds'),
            SizedBox(
              width: 50,
              child: TextField(
                controller: secsController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                decoration: const InputDecoration.collapsed(
                  hintText: '',
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                showCursor: true,
                onSubmitted: (value) {
                  onOffTap(secsController);
                },
                onTapOutside: (event) {
                  onOffTap(secsController);
                },
                onTap: () {
                  onTap(secsController);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
