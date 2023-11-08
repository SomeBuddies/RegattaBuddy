import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:regatta_buddy/utils/form_utils.dart';

class EventFormSubPage extends HookWidget {
  final GlobalKey<FormState> _formKey;
  final void Function(String) nameSubmitHandler;
  final void Function(String) descriptionSubmitHandler;
  final void Function(DateTime) dateSubmitHandler;
  final void Function(TimeOfDay) timeSubmitHandler;

  const EventFormSubPage(
    this._formKey,
    this.nameSubmitHandler,
    this.descriptionSubmitHandler,
    this.dateSubmitHandler,
    this.timeSubmitHandler, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final eventNameController = useTextEditingController();
    final eventDescriptionController = useTextEditingController();
    final eventDateController = useTextEditingController();
    final eventTimeController = useTextEditingController();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RBRequiredInputFormField(
            label: 'Event name',
            controller: eventNameController,
            handler: nameSubmitHandler,
          ),
          RBRequiredTextAreaFormField(
            label: 'Event description',
            controller: eventDescriptionController,
            handler: descriptionSubmitHandler,
          ),
          RBRequiredDateFormField(
            label: 'Event date',
            controller: eventDateController,
            handler: dateSubmitHandler,
          ),
          RBRequiredTimeFormField(
            label: 'Event time',
            controller: eventTimeController,
            handler: timeSubmitHandler,
          ),
        ],
      ),
    );
  }
}
