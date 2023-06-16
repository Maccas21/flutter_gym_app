import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightRepInput extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController repsController;

  const WeightRepInput(
      {super.key,
      required this.weightController,
      required this.repsController});

  void increaseValue(TextEditingController controller, int maxDigits) {
    // close keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    if (controller.text == '') {
      controller.text = '1';
      return;
    }
    if (int.parse(controller.text) < pow(10, maxDigits) - 1) {
      controller.text = (int.parse(controller.text) + 1).toString();
    }
  }

  void decreaseValue(TextEditingController controller) {
    // close keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    if (controller.text == '') {
      controller.text = '0';
      return;
    }
    if (int.parse(controller.text) > 0) {
      controller.text = (int.parse(controller.text) - 1).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Text('Weight'),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    decreaseValue(weightController);
                  },
                  icon: const Icon(Icons.remove),
                  splashRadius: 15,
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: weightController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                    ],
                    decoration: const InputDecoration.collapsed(
                      hintText: '',
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    showCursor: false,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    increaseValue(weightController, 5);
                  },
                  icon: const Icon(Icons.add),
                  splashRadius: 15,
                ),
              ],
            )
          ],
        ),
        Column(
          children: [
            const Text('Reps'),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    decreaseValue(repsController);
                  },
                  icon: const Icon(Icons.remove),
                  splashRadius: 15,
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: repsController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: const InputDecoration.collapsed(
                      hintText: '',
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    showCursor: false,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    increaseValue(repsController, 3);
                  },
                  icon: const Icon(Icons.add),
                  splashRadius: 15,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
