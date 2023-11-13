class AssignedPointsInRound {
  final int round;
  final int points;

  AssignedPointsInRound(this.round, this.points);

  AssignedPointsInRound.fromString(String data)
      : round = int.parse(data.split(":")[0]),
        points = int.parse(data.split(":")[1]);

  @override
  String toString() {
    return "$round:$points";
  }
}
