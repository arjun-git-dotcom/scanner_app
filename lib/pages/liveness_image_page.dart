import 'dart:typed_data';

import 'package:flutter/material.dart';

class LivenessImagePage extends StatefulWidget {
  final Uint8List? image;
  const LivenessImagePage({super.key, required this.image});

  @override
  State<LivenessImagePage> createState() => _LivenessImagePageState();
}

class _LivenessImagePageState extends State<LivenessImagePage> {
  
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      body: Center(
        child: widget.image != null
            ? Image.memory(widget.image!)
            : Text("No image available"),
      ),
    );
  }
}
