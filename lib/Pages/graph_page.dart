import 'package:flutter/material.dart';

class GraphTab extends StatelessWidget {
  const GraphTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: const Center(
        child: Column(
          children: [
            Text("Graph Tab"),
          ],
        ),
      ),
    );
  }
}
