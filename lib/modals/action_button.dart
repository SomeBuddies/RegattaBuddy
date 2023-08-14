import 'package:flutter/material.dart';
import 'package:regatta_buddy/utils/constants.dart' as constants;

class ActionButton extends StatelessWidget {

  ActionButton({
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
  Function? additionalCallback;

  void setAdditionalCallback(Function callback) {
    additionalCallback = callback;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(size, size),

      child: Material(
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(constants.elementsBorderRadius)),
        child: InkWell(
          splashColor: Colors.lightBlueAccent,
          onTap: () => {
            onTap(),
            if (additionalCallback != null) {
              additionalCallback!()
            }
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
}
