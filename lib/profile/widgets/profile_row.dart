import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileRow extends StatelessWidget {
  final String title;
  final String value;
  ProfileRow({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    bool isGmail = value.contains('@gmail');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
          isGmail
              ? Text(
            value,
            style: TextStyle(
                fontSize: 18,
                color: Colors.blue.withOpacity(0.6),
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue,
                fontWeight: FontWeight.bold),
          )
              : Text(value,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          Divider(color: Colors.grey, thickness: 1, height: 20),
        ],
      ),
    );
  }
}