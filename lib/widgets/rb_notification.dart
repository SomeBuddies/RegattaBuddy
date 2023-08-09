import 'package:flutter/material.dart';
import 'package:regatta_buddy/utils/constants.dart' as constants;

class RBNotification extends StatelessWidget {
  const RBNotification({
    super.key,
    required this.uuid,
    required this.title,
    required this.onClose,
    this.height = 80,
    this.additionalText = "",
  });

  final double height;
  final String uuid;
  final String title;
  final String additionalText;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width - 10;

    return Container(
      width: containerWidth,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.all(Radius.circular(constants.elementsBorderRadius)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Text(additionalText, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => onClose(),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
