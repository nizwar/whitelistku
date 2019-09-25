import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData icon;
  final int maxLines;
  final void Function(String) onSubmitted;
  final void Function(String) validator;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final bool autovalidate;
  const CustomTextField(
      {Key key,
      this.label,
      @required this.controller,
      this.focusNode,
      this.icon,
      this.maxLines,
      this.autovalidate,
      this.onSubmitted,
      this.textInputType,
      this.textInputAction,
      this.validator})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 10.0),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: textInputAction ?? TextInputAction.continueAction,
        autovalidate: autovalidate ?? false,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(5, 5.0, 5.0, 0),
            labelText: label,
            prefixIcon: icon == null ? null : Icon(icon),
            border: InputBorder.none),
        maxLines: maxLines,
        keyboardType: textInputType ?? TextInputType.text,
      ),
    );
  }
}
