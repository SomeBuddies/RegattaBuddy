import 'package:flutter/material.dart';
import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/add_score_form.dart';
import 'package:regatta_buddy/models/message.dart';
import 'package:regatta_buddy/pages/race/messages_list.dart';
import 'package:regatta_buddy/utils/constants.dart' as constants;

Future<void> showActionsDialog(
  BuildContext context,
  List<ActionButton> actions,
) async {
  await Future.delayed(const Duration(seconds: 0));
  if (context.mounted) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext cxt) {
        var autoClosingActions = actions.map((action) {
          return action.copyWith(
              additionalCallback: () => Navigator.of(cxt).pop(false));
        }).toList();

        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(constants.elementsBorderRadius),
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(constants.elementsBorderRadius),
              ),
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

Future<void> showSelectWithInputDialog(BuildContext context,
    List<String> options, String eventId, int round) async {
  await Future.delayed(const Duration(seconds: 0));

  if (context.mounted) {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext cxt) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(constants.elementsBorderRadius),
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(constants.elementsBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 270,
                  child: AddScoreForm(options, eventId, round),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> showMessagesDialog(BuildContext context, List<Message> messages) async {
  await Future.delayed(const Duration(seconds: 0));

  if (context.mounted) {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext cxt) {
        return AlertDialog(
          title: const Text('Messages'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(constants.elementsBorderRadius),
          ),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(

              child: Column(
                children: messages.map((message) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: MessageListTile(message: message),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}