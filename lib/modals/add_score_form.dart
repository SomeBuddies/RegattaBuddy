import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:regatta_buddy/models/assigned_points_in_round.dart';
import 'package:regatta_buddy/models/event.dart';
import 'package:regatta_buddy/models/team.dart';
import 'package:regatta_buddy/providers/firebase_writer_service_provider.dart';
import 'package:regatta_buddy/providers/repository_providers.dart';
import 'package:regatta_buddy/utils/logging/logger_helper.dart';

class AddScoreForm extends ConsumerStatefulWidget {
  final logger = getLogger('AddScoreForm');
  final List<Team> teams;
  final Event event;
  final int round;

  AddScoreForm(
    this.teams,
    this.event,
    this.round, {
    super.key,
  });

  @override
  ConsumerState<AddScoreForm> createState() => _AddScoreFormState();
}

class _AddScoreFormState extends ConsumerState<AddScoreForm> {
  static final RegExp allowNegativeAndPositiveNumbersRegExp =
      RegExp(r'^-?\d{0,5}');
  late Team selectedTeam;

  final pointsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    selectedTeam = widget.teams[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text("Select a team and add points"),
          DropdownButton<Team>(
            value: selectedTeam,
            items: widget.teams.map<DropdownMenuItem<Team>>((Team value) {
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
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  allowNegativeAndPositiveNumbersRegExp),
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SuggestedPointsButton(
                  pointsController: pointsController,
                  points: "-10",
                  color: Colors.red),
              SuggestedPointsButton(
                  pointsController: pointsController,
                  points: "-5",
                  color: Colors.red),
              SuggestedPointsButton(
                  pointsController: pointsController,
                  points: "5",
                  color: Colors.green),
              SuggestedPointsButton(
                  pointsController: pointsController,
                  points: "10",
                  color: Colors.green),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Either<String, String> response = await updateTeamPoints();

                String responseText =
                    response.fold((error) => "Failed to add points", (success) {
                  // TODO send event to db about points change
                  return "Successfully added ${pointsController.value.text} points to $selectedTeam";
                });
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(responseText)),
                );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
            ),
            child: const Text("ADD",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<Either<String, String>> updateTeamPoints() async {
    final firebaseWriterService = ref.watch(firebaseWriterServiceProvider);

    try {
      final currentScoreResponse = await firebaseWriterService.getTeamScore(
        widget.event.id,
        selectedTeam.id,
        widget.round,
      );

      int currentScore = 0;

      currentScoreResponse.fold(
        (error) {
          widget.logger
              .e("Score update failed, couldn't get current score: $error");
          return left("Score update failed, couldn't get current score");
        },
        (score) {
          currentScore = score;
        },
      );

      final points = int.parse(pointsController.value.text);
      final newScore = currentScore + points;

      final response = await firebaseWriterService.setPointsToTeam(
        widget.event.id,
        selectedTeam.id,
        widget.round,
        newScore,
      );

      ref.read(eventMessageSenderProvider).assignPoints(
            widget.event,
            selectedTeam,
            AssignedPointsInRound(widget.round, points).toString(),
          );

      if (response.isLeft()) {
        throw Exception(response.fold((l) => l, (r) => r));
      }
    } catch (e) {
      widget.logger.e("Score update failed: ${e.toString()}");
      return left(e.toString());
    }
    return right("Success");
  }
}

class SuggestedPointsButton extends StatelessWidget {
  const SuggestedPointsButton({
    super.key,
    required this.pointsController,
    required this.points,
    required this.color,
  });

  final TextEditingController pointsController;
  final String points;
  final MaterialColor color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: () => pointsController.text = points,
      child: Text(points),
    );
  }
}
