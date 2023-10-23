import 'package:flutter/material.dart';

class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Me Page'),
      ),
      body: const Center(
        child: Text('This is the Me Page'),
      ),
    );
  }
}
