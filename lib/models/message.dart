class Message {
  final MessageType type;
  final MessageReceiverType receiverType;
  final String? teamId;
  final String? value;
  final String timestamp;
  String? teamName;

  Message(
      {required this.type,
      required this.receiverType,
      this.teamId,
      this.value,
      this.teamName,
      required this.timestamp});

  Message.fromJson(Map<String, String> json)
      : type = MessageType.values.byName(json['type']!),
        receiverType = MessageReceiverType.values.byName(json['receiverType']!),
        teamId = json['teamId'],
        value = json['value'],
        timestamp = json['timestamp']!;

  Map<String, String> toJson() {
    Map<String, String> json = {
      'type': type.name,
      'receiverType': receiverType.name,
      'timestamp': timestamp
    };
    if (teamId != null) json['teamId'] = teamId!;
    if (value != null) json['value'] = value!;
    return json;
  }

  bool isForAll() {
    return receiverType == MessageReceiverType.all;
  }

  bool isForTeam(String? id) {
    return receiverType == MessageReceiverType.team && teamId == id;
  }

  bool isForReferee(String? id) {
    return receiverType == MessageReceiverType.referee && id == null;
  }

  get convertedTimestamp {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  }
}

enum MessageType {
  startEvent,
  endEvent,
  directedTextMessage,
  pointsAssignment,
  roundStarted,
  roundFinished,
  requestHelp,
  protest,
  reportProblem
}

enum MessageReceiverType { all, referee, team }

// contract:
// type: roundStarted
// receiverType: all
// value: "${roundNumber},${datetime}"

// type: protest
// receiverType: referee
// teamId: team that protests
// value: problematic team

// type: requestHelp
// receiverType: referee
// teamId: team that needs help

// type: reportProblem
// receiverType: referee
// teamId: team that reports problem
// value: problem description
