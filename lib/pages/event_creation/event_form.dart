import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:regatta_buddy/extensions/datetime_extension.dart';
import 'package:regatta_buddy/utils/form_utils.dart';

class EventFormSubPage extends HookWidget {
  final GlobalKey<FormState> _formKey;
  final void Function(String) nameSubmitHandler;
  final void Function(String) descriptionSubmitHandler;
  final void Function(DateTime) dateSubmitHandler;
  final void Function(TimeOfDay) timeSubmitHandler;
  final String? initialEventName;
  final String? initialDescription;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;

  const EventFormSubPage(
    this._formKey,
    this.nameSubmitHandler,
    this.descriptionSubmitHandler,
    this.dateSubmitHandler,
    this.timeSubmitHandler,
    this.initialEventName,
    this.initialDescription,
    this.initialDate,
    this.initialTime, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String date = initialDate != null
        ? DateFormat('dd.MM.yyyy').format(initialDate!)
        : '';
    final String time = initialTime != null
        ? DateFormat("HH:mm").format(DateTime.now().withTimeOfDay(initialTime!))
        : '';

    final eventNameController = useTextEditingController
        .fromValue(TextEditingValue(text: initialEventName ?? ""));
    final eventDescriptionController = useTextEditingController
        .fromValue(TextEditingValue(text: initialDescription ?? ""));
    final eventDateController =
        useTextEditingController.fromValue(TextEditingValue(text: date));
    final eventTimeController =
        useTextEditingController.fromValue(TextEditingValue(text: time));

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RBRequiredInputFormField(
            label: 'Nazwa',
            controller: eventNameController,
            handler: nameSubmitHandler,
          ),
          RBRequiredTextAreaFormField(
            label: 'Opis',
            controller: eventDescriptionController,
            handler: descriptionSubmitHandler,
          ),
          RBRequiredDateFormField(
            label: 'Data',
            controller: eventDateController,
            handler: dateSubmitHandler,
          ),
          RBRequiredTimeFormField(
            label: 'Godzina',
            controller: eventTimeController,
            handler: timeSubmitHandler,
          ),
        ],
      ),
    );
  }
}
