import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final dynamic update;
  final dynamic validate;
  final Icon prefixIcon;
  final TextEditingController controller;

  const InputField({
    super.key,
    required this.hint,
    required this.update,
    required this.validate,
    required this.prefixIcon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: update,
      validator: validate,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          prefixIcon.icon,
          color: Colors.white,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
        errorStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
