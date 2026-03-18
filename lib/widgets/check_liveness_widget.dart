import 'package:flutter/material.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:scanning_app/pages/liveness_image_page.dart';

class CheckLivenessWidget {
  final BuildContext context;
  CheckLivenessWidget({required this.context});

  Future<void> checkLiveness() async {
    var response = await FaceSDK.instance.startLiveness();

    if (!context.mounted) return;
    if (response.image == null) return;

    if (response.liveness == LivenessStatus.PASSED) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LivenessImagePage(image:response.image)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Liveness verification inconclusive. Please try again"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
