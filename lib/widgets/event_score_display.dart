import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:regatta_buddy/models/event.dart';

class EventScoreDisplay extends HookConsumerWidget {
  final Event event;
  const EventScoreDisplay(
    this.event, {
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}
