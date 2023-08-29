import 'package:flutter/material.dart';
import 'package:regatta_buddy/utils/constants.dart' as constants;

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.size = 20,
    this.iconData = Icons.question_mark,
    this.title = "",
    required this.onTap,
    this.additionalCallback,
  });

  final double size;
  final IconData iconData;
  final String title;
  final Function onTap;
  final Function? additionalCallback;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(size, size),
      child: Material(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constants.elementsBorderRadius),
        ),
        child: InkWell(
          splashColor: Colors.lightBlueAccent,
          onTap: () => {
            onTap(),
            additionalCallback?.call(),
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(iconData, size: 80),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  ActionButton copyWith({
    Key? key,
    double? size,
    IconData? iconData,
    String? title,
    Function? onTap,
    Function? additionalCallback,
  }) =>
      ActionButton(
        key: key ?? this.key,
        size: size ?? this.size,
        iconData: iconData ?? this.iconData,
        title: title ?? this.title,
        onTap: onTap ?? this.onTap,
        additionalCallback: additionalCallback ?? this.additionalCallback,
      );
}
