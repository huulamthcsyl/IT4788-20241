import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {

  final String title;
  final dynamic action;

  const SubmitButton({
    super.key,
    required this.title,
    required this.action,
  });


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: Text(
          title,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}