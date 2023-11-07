class Message {
  final MessageType type;
  final MessageReceiverType receiverType;
  final String? teamId;
  final String? value;

  Message(
      {required this.type,
      required this.receiverType,
      this.teamId,
      this.value});

  Message.fromJson(Map<String, String> json)
      : type = MessageType.values.byName(json['type']!),
        receiverType = MessageReceiverType.values.byName(json['receiverType']!),
        teamId = json['teamId'],
        value = json['value'];

  Map<String, String> toJson() {
    Map<String, String> json = {
      'type': type.name,
      'receiverType': receiverType.name
    };
    if (teamId != null) json['teamId'] = teamId!;
    if (value != null) json['value'] = value!;
    return json;
  }
}

enum MessageType {
  startEvent,
}

enum MessageReceiverType { all, referee, team }
