import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:regatta_buddy/extensions/datetime_extension.dart';

String? requiredFieldValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

class RBTextFormFieldDecoration extends InputDecoration {
  const RBTextFormFieldDecoration({
    super.labelText,
  }) : super(
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(fontSize: 20),
        );
}

class RBInputFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const RBInputFormField({
    required this.label,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        decoration: RBTextFormFieldDecoration(labelText: label),
        controller: controller,
      ),
    );
  }
}

class RBRequiredInputFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function(String) handler;

  const RBRequiredInputFormField({
    required this.label,
    required this.controller,
    required this.handler,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        decoration: RBTextFormFieldDecoration(labelText: label),
        validator: requiredFieldValidator,
        onSaved: (newValue) => handler(newValue!),
      ),
    );
  }
}

class RBRequiredTextAreaFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function(String) handler;

  const RBRequiredTextAreaFormField({
    required this.label,
    required this.controller,
    required this.handler,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        decoration: RBTextFormFieldDecoration(labelText: label),
        validator: requiredFieldValidator,
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 10,
        onSaved: (newValue) => handler(newValue!),
      ),
    );
  }
}

class RBRequiredTimeFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function(TimeOfDay) handler;

  const RBRequiredTimeFormField({
    required this.label,
    required this.controller,
    required this.handler,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        decoration: RBTextFormFieldDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please pick a time';
          }
          return null;
        },
        readOnly: true,
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 12, minute: 0),
          );

          if (pickedTime != null) {
            controller.text = DateFormat("HH:mm")
                .format(DateTime.now().withTimeOfDay(pickedTime));
          }
        },
        onSaved: (newValue) {
          final date = DateFormat("HH:mm").parse(newValue!);
          handler(TimeOfDay(hour: date.hour, minute: date.minute));
        },
      ),
    );
  }
}

class RBRequiredDateFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final void Function(DateTime) handler;

  const RBRequiredDateFormField({
    required this.label,
    required this.controller,
    required this.handler,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        decoration: RBTextFormFieldDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please pick a date';
          }
          return null;
        },
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            controller.text = DateFormat('dd.MM.yyyy').format(pickedDate);
          }
        },
        onSaved: (newValue) {
          handler(DateFormat('dd.MM.yyyy').parse(newValue!));
        },
      ),
    );
  }
}
