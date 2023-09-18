import 'package:flutter/material.dart';
import 'package:regatta_buddy/utils/form_utils.dart';

class EventFormSubPage extends StatefulWidget {
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
  State<EventFormSubPage> createState() => _EventFormSubPageState();
}

class _EventFormSubPageState extends State<EventFormSubPage> {
  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RBRequiredInputFormField(
            label: 'Event name',
            controller: eventNameController,
            handler: widget.nameSubmitHandler,
          ),
          RBRequiredTextAreaFormField(
            label: 'Event description',
            controller: eventDescriptionController,
            handler: widget.descriptionSubmitHandler,
          ),
          RBRequiredDateFormField(
            label: 'Event date',
            controller: eventDateController,
            handler: widget.dateSubmitHandler,
          ),
          RBRequiredTimeFormField(
            label: 'Event time',
            controller: eventTimeController,
            handler: widget.timeSubmitHandler,
          ),
        ],
      ),
    );
  }
}
