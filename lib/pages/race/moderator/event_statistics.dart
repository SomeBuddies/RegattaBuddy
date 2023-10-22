import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:regatta_buddy/enums/round_status.dart';
import 'package:regatta_buddy/providers/race_events.dart';
import 'package:regatta_buddy/utils/constants.dart' as constants;
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class EventStatistics extends ConsumerWidget {
  EventStatistics({super.key});

  final logger = getLogger("EventStatistics");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRound = ref.watch(currentRoundProvider);
    final currentRoundStatus = ref.watch(currentRoundStatusProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(constants.elementsBorderRadius),
          bottomRight: Radius.circular(constants.elementsBorderRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Online",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "2 / 7",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Time",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "0:00:00",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Round",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$currentRound / 5",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [getActionForRound(ref, currentRoundStatus)],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector getActionForRound(WidgetRef ref, RoundStatus roundStatus) {
    if (roundStatus == RoundStatus.started) {
      return GestureDetector(
        child: const Icon(
          Icons.pause,
          size: 40,
        ),
        onTap: () {
          ref.read(currentRoundStatusProvider.notifier).finish();
          logger.i("Round finished");
          // TODO send event to server
        },
      );
    }
    return GestureDetector(
      child: const Icon(
        Icons.play_arrow,
        size: 40,
      ),
      onTap: () {
        ref.read(currentRoundProvider.notifier).increment();
        ref.read(currentRoundStatusProvider.notifier).start();
        logger.i("Round started");
        // TODO send event to server
      },
    );
  }
}
