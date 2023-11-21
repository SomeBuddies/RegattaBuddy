import 'dart:async';

import 'package:flutter/material.dart';
import 'package:regatta_buddy/modals/action_button.dart';
import 'package:regatta_buddy/modals/add_score_form.dart';
import 'package:regatta_buddy/modals/report_problem_form.dart';
import 'package:regatta_buddy/modals/report_protest_form.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/message.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/pages/race/messages_list.dart';
import 'package:regatta_buddy/services/repositories/team_repository.dart';
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

Future<void> showSelectWithInputDialog(
  BuildContext context,
  List<Team> teams,
  Event event,
  int round,
) async {
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
                  child: AddScoreForm(teams, event, round),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<void> showMessagesDialog(
  BuildContext context,
  List<Message> messages,
) async {
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

Future<void> showDisappearingMessageDialog(
  BuildContext context,
  Message message, {
  String? customTitle,
  Duration? duration,
}) async {
  Timer? dialogTimer;

  if (context.mounted) {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext cxt) {
        dialogTimer = Timer(
          duration ?? const Duration(seconds: 5),
          () => Navigator.of(context).pop(),
        );
        return WillPopScope(
            onWillPop: () async {
              dialogTimer?.cancel();
              return true;
            },
            child: AlertDialog(
              title: customTitle != null
                  ? Text(customTitle)
                  : const Text('Message'),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(constants.elementsBorderRadius),
              ),
              content: SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: MessageListTile(message: message),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          dialogTimer?.cancel();
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}

Future<void> showReportProblemDialog(
  BuildContext context,
  String eventId,
  String teamId,
) async {
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
                  child: ReportProblemForm(eventId: eventId, teamId: teamId),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Todo use consumer instead of passing repository
Future<void> showProtestDialog(
  BuildContext context,
  String eventId,
  String teamId,
  TeamRepository repo,
) async {
  await Future.delayed(const Duration(seconds: 0));

  List<Team> teams = await repo.getTeams();

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
                  child: ProtestForm(
                      eventId: eventId, teams: teams, teamId: teamId),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
