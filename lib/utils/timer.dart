import 'dart:async' as flutter_timer;

class Timer {
  flutter_timer.Timer? _timer;
  Duration _duration = const Duration(seconds: 0);
  final Duration interval;
  void Function(Duration)? changeCallback;
  void Function(Duration)? additionalChangeCallback;

  Timer({this.changeCallback, this.interval = const Duration(seconds: 1)});

  void start() {
    _timer = flutter_timer.Timer.periodic(
      interval,
      (timer) {
        _duration += interval;
        changeCallback?.call(_duration);
        additionalChangeCallback?.call(_duration);
      },
    );
  }

  void startFrom(DateTime from) {
    _duration = DateTime.now().difference(from);
    start();
  }

  void resume() {
    start();
  }

  void pause() {
    _timer?.cancel();
  }

  void setAdditionalChangeCallback(void Function(Duration)? callback) {
    additionalChangeCallback = callback;
  }

  void stop() {
    _timer?.cancel();
  }

  get duration => _duration;

  String get formattedDuration {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String twoDigitMinutes = twoDigits(_duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(_duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(_duration.inHours);

    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}
