import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regatta_buddy/providers/firebase_writer_service_provider.dart';

class AddPointsForm extends ConsumerStatefulWidget {
  final List<String> selectOptions;
  final String eventId;
  final int round;

  const AddPointsForm(
    this.selectOptions,
    this.eventId,
    this.round, {
    super.key,
  });

  @override
  ConsumerState<AddPointsForm> createState() => _AddPointsFormState();
}

class _AddPointsFormState extends ConsumerState<AddPointsForm> {
  late String selectedTeam;

  final pointsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    selectedTeam = widget.selectOptions[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text("Select a team and add points"),
          DropdownButton<String>(
            value: selectedTeam,
            items: widget.selectOptions
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 30),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedTeam = newValue!;
              });
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Points',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some points';
              }
              return null;
            },
            controller: pointsController,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final response = await ref
                    .watch(firebaseWriterServiceProvider)
                    .setPointsToTeam(
                      widget.eventId,
                      selectedTeam,
                      widget.round,
                      int.parse(pointsController.value.text),
                    );

                String responseText = response.fold(
                  (error) => "Failed to add points",
                  (success) =>
                      "Successfully added ${pointsController.value.text} points to $selectedTeam",
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(responseText)),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text("ADD"),
          ),
        ],
      ),
    );
  }
}
