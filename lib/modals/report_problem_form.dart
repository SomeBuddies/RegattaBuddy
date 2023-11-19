import 'package:flutter/material.dart';
import 'package:regatta_buddy/services/event_message_sender.dart';

class ReportProblemForm extends StatefulWidget {
  final String eventId;
  final String teamId;

  const ReportProblemForm({super.key, required this.eventId, required this.teamId});

  @override
  _ReportProblemFormState createState() => _ReportProblemFormState();
}

class _ReportProblemFormState extends State<ReportProblemForm> {
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text("Describe the problem"),
          const SizedBox(height: 30),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please describe the problem';
              }
              return null;
            },
            controller: descriptionController,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                EventMessageSender.reportProblem(widget.eventId, widget.teamId, descriptionController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Reported problem to referee"),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
            ),
            child: const Text("Send to referee",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}