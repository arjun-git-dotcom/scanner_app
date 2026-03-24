import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:scanning_app/pages/liveness_image_page.dart';

class CheckLivenessWidget {
  final BuildContext context;
  CheckLivenessWidget({required this.context});

  void configLivenessUi() async {
    var c = FaceSDK.instance.customization;

    c.colors.onboardingScreenBackground = Colors.green;
    c.colors.onboardingScreenStartButtonBackground = Colors.white;
    c.colors.onboardingScreenStartButtonTitle = Colors.orange;
    c.colors.onboardingScreenMessageLabelsText = Colors.white;
    c.colors.onboardingScreenTitleLabelText = Colors.brown;
    c.colors.onboardingScreenSubtitleLabelText = Colors.indigo;

    c.images.onboardingScreenAccessories = await rootBundle.load(
      "assets/transparent-holding-phone-60db2a84d4b5c6.2067165816249760048713.jpg",
    );

    c.colors.cameraScreenBackHintLabelBackground = Colors.blue;
    c.colors.cameraScreenSectorTarget = Colors.red;
    c.colors.cameraScreenStrokeNormal = Colors.lime;
    c.colors.cameraScreenFrontHintLabelText = Colors.purple;

    c.colors.retryScreenBackground = Colors.red;
    c.colors.processingScreenBackground = Colors.amberAccent;
    c.images.processingScreenCloseButton = await rootBundle.load(
      "assets/transparent-holding-phone-60db2a84d4b5c6.2067165816249760048713.jpg",
    );
    c.images.retryScreenHintEnvironment = await rootBundle.load(
      "assets/transparent-holding-phone-60db2a84d4b5c6.2067165816249760048713.jpg",
    );
  }

  Future<void> checkLiveness() async {
    configLivenessUi();
    var response = await FaceSDK.instance.startLiveness();

    if (!context.mounted) return;
    if (response.image == null) return;

    if (response.liveness == LivenessStatus.PASSED) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LivenessImagePage(image: response.image),
        ),
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
