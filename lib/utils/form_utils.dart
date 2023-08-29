import 'package:flutter/material.dart';

InputDecoration customTextFormFieldDecoration(String labelText) => InputDecoration(
      border: const OutlineInputBorder(),
      labelText: labelText,
      labelStyle: const TextStyle(fontSize: 20),
    );

String? requiredFieldValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }
  return null;
}

Widget customRequiredInputFormField(String label, TextEditingController controller) => Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        decoration: customTextFormFieldDecoration(label),
        validator: requiredFieldValidator,
      ),
    );

Widget customRequiredTextAreaFormField(String label, TextEditingController controller) => Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        decoration: customTextFormFieldDecoration(label),
        validator: requiredFieldValidator,
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 10,
      ),
    );
