import 'package:flutter/material.dart';

class EmailSentScreen extends StatelessWidget {
  const EmailSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Sent'),
      ),
      body: Center(
        child: Text('Email Sent Screen Content'),
      ),
    );
  }
}