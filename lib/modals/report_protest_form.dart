import 'package:flutter/material.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/services/event_message_sender.dart';

class ProtestForm extends StatefulWidget {
  final String eventId;
  final String teamId;
  final List<Team> teams;

  const ProtestForm({
    super.key,
    required this.eventId,
    required this.teams,
    required this.teamId,
  });

  @override
  State<ProtestForm> createState() => _ProtestFormState();
}

class _ProtestFormState extends State<ProtestForm> {
  late Team selectedTeam;
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    selectedTeam = widget.teams.where((team) => team.id != widget.teamId).first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text("Select a problematic team and describe protest"),
          const SizedBox(height: 20),
          DropdownButton<Team>(
            value: selectedTeam,
            items: widget.teams
                .where((team) => team.id != widget.teamId)
                .map<DropdownMenuItem<Team>>((Team value) {
              return DropdownMenuItem<Team>(
                value: value,
                child: Text(
                  value.name,
                  style: const TextStyle(fontSize: 30),
                ),
              );
            }).toList(),
            onChanged: (Team? newValue) {
              setState(() {
                selectedTeam = newValue!;
              });
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
            controller: descriptionController,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                EventMessageSender.protest(widget.eventId, widget.teamId,
                    selectedTeam.name, descriptionController.text);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Protest submitted for ${selectedTeam.name}"),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
            ),
            child: const Text(
              "Send to referee",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
