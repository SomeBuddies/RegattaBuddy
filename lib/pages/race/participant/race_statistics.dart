import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/enums/round_status.dart';
import 'package:regatta_buddy/providers/location_providers.dart';
import 'package:regatta_buddy/providers/race_events.dart';
import 'package:regatta_buddy/utils/constants.dart' as constants;
import 'package:regatta_buddy/utils/logging/logger_helper.dart';
import 'package:regatta_buddy/utils/timer.dart';

class RaceStatistics extends ConsumerStatefulWidget {
  final String eventId;
  final Timer timer;
  final double height;

  const RaceStatistics({
    required this.eventId,
    required this.timer,
    this.height = 100,
    super.key,
  });

  @override
  ConsumerState<RaceStatistics> createState() => _RaceStatisticsState();
}

class _RaceStatisticsState extends ConsumerState<RaceStatistics> {
  Duration time = Duration.zero;
  final logger = getLogger("RaceStatistics");

  @override
  void initState() {
    widget.timer.setAdditionalChangeCallback(onTimeChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.timer.setAdditionalChangeCallback(null);
    super.dispose();
  }

  void onTimeChange(Duration duration) {
    setState(() {
      time = duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRound = ref.watch(currentRoundProvider(widget.eventId));
    final currentRoundStatus = ref.watch(currentRoundStatusProvider);

    final currentSpeed = ref.watch(locationSpeedProvider);

    return Container(
      height: widget.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(constants.elementsBorderRadius),
          bottomRight: Radius.circular(constants.elementsBorderRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Runda",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$currentRound",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (currentRoundStatus == RoundStatus.finished)
                      const Icon(
                        Icons.pause_circle_filled,
                        color: Colors.red,
                        size: 20,
                      ),
                  ],
                ),
              ],
            ),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Aktualna prędkość",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${currentSpeed.toStringAsFixed(2)}km/h",
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
      ),
    );
  }
}
