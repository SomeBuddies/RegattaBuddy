import 'package:flutter/material.dart';
import 'package:regatta_buddy/utils/form_utils.dart';

class EventFormSubPage extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final String initialName;
  final String initialDescription;
  final void Function(String) nameChangeHandler;
  final void Function(String) descriptionChangeHandler;

  const EventFormSubPage(
    this._formKey,
    this.initialName,
    this.initialDescription,
    this.nameChangeHandler,
    this.descriptionChangeHandler, {
    super.key,
  });

  @override
  State<EventFormSubPage> createState() => _EventFormSubPageState();
}

class _EventFormSubPageState extends State<EventFormSubPage> {
  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    eventNameController.text = widget.initialName;
    eventDescriptionController.text = widget.initialDescription;
    eventNameController.addListener(
      () => widget.nameChangeHandler(eventNameController.text),
    );
    eventDescriptionController.addListener(
      () => widget.descriptionChangeHandler(eventDescriptionController.text),
    );
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customRequiredInputFormField('Event name', eventNameController),
          customRequiredTextAreaFormField('Event description', eventDescriptionController),
        ],
      ),
    );
  }
}
