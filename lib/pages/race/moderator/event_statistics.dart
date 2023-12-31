import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:regatta_buddy/providers/race_events.dart';
import 'package:regatta_buddy/utils/constants.dart' as constants;
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/utils/timer.dart';

class EventStatistics extends ConsumerStatefulWidget {
  final String eventId;
  final Timer timer;

  const EventStatistics({
    required this.eventId,
    required this.timer,
    super.key,
  });

  @override
  ConsumerState<EventStatistics> createState() => _EventStatisticsState();
}

class _EventStatisticsState extends ConsumerState<EventStatistics> {
  Duration time = Duration.zero;
  final logger = getLogger("EventStatistics");

  @override
  void initState() {
    widget.timer.setAdditionalChangeCallback(onTimeChange);
    super.initState();
  }

  void onTimeChange(Duration duration) {
    setState(() {
      time = duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRound = ref.watch(currentRoundProvider(widget.eventId));

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Czas",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.timer.formattedDuration.toString(),
                  style: const TextStyle(
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
                    Text(
                      currentRound == 0 ? "Przygotowania" : "Runda",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentRound == 0 ? "" : "$currentRound",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
