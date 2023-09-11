// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class IconWithText extends StatelessWidget {
  final Icon icon;
  final String label;
  final TextStyle? style;

  const IconWithText({
    required this.icon,
    required this.label,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 3,
        ),
        Text(
          label,
          style: style,
        ),
      ],
    );
  }
}
