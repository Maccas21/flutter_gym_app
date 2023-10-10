import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gym_app/Model/decimal_text_input_formatter.dart';
import 'package:flutter_gym_app/Util/time_input.dart';
import 'package:intl/intl.dart';

class DistanceTimeInput extends StatelessWidget {
  final TextEditingController distController;
  final TextEditingController hoursController;
  final TextEditingController minsController;
  final TextEditingController secsController;

  const DistanceTimeInput({
    super.key,
    required this.distController,
    required this.hoursController,
    required this.minsController,
    required this.secsController,
  });

  void onTap(TextEditingController controller) {
    if (controller.text == '0') {
      controller.text = '';
    }
  }

  void onOffTap(TextEditingController controller) {
    if (controller.text == '') {
      controller.text = '0';
    }

    String formatedNumber =
        NumberFormat('0.###').format(double.parse(controller.text));
    controller.text = formatedNumber;

    // closes keyboard
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const Text('Distance'),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: distController,
                  inputFormatters: [
                    DecimalTextInputFormatter(),
                    LengthLimitingTextInputFormatter(7),
                  ],
                  decoration: const InputDecoration.collapsed(
                    hintText: '',
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  showCursor: true,
                  onSubmitted: (value) {
                    onOffTap(distController);
                  },
                  onTapOutside: (event) {
                    onOffTap(distController);
                  },
                  onTap: () {
                    onTap(distController);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: TimeInput(
                hoursController: hoursController,
                minsController: minsController,
                secsController: secsController,
                compact: true)),
      ],
    );
  }
}
