import 'package:flutter/material.dart';
import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/utils/constants.dart' as constants;

Future<void> showActionsDialog(
    BuildContext context, List<ActionButton> actions) async {
  await Future.delayed(const Duration(seconds: 0));
  if (context.mounted) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext cxt) {
        var autoClosingActions = actions.map((action) {
          action.setAdditionalCallback(() => Navigator.of(cxt).pop(false));
          return action;
        }).toList();

        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(constants.elementsBorderRadius),
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(constants.elementsBorderRadius)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: autoClosingActions,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
