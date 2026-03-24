import 'package:flutter/material.dart';
import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
import 'package:scanning_app/pages/details_page.dart';

class ScanDocumentWidget {
  final BuildContext context;
  ScanDocumentWidget({required this.context});

  void configureUI() async {
    final c = DocumentReader.instance.customization;
    final f = DocumentReader.instance.functionality;
    c.backgroundMaskColor = Colors.amberAccent;
    c.cameraFrameActiveColor = Colors.blue;
    c.status = "Hello world";
    c.statusTextFont = Font("sans-serif-thin", size: 14, style: FontStyle.BOLD);
    c.statusTextColor = Colors.deepOrange;
    c.cameraFrameShapeType = FrameShapeType.CORNER;

    f.showCaptureButton = true;
    f.showCameraSwitchButton = true;
    f.showTorchButton = true;
    f.showCaptureButtonDelayFromStart = 0;
    f.showCaptureButtonDelayFromDetect = 0;
  }

  Future<void> scanDocument() async {
    configureUI();
    DocumentReader.instance.startScanner(
      ScannerConfig.withScenario(Scenario.MRZ),
      (action, results, error) async {
        if (action == DocReaderAction.COMPLETE ||
            action == DocReaderAction.TIMEOUT) {
          if (results != null) {
            var name = await results.textFieldValueByType(
              FieldType.SURNAME_AND_GIVEN_NAMES,
            );
            var nationality = await results.textFieldValueByType(
              FieldType.NATIONALITY,
            );
            var dateofbirth = await results.textFieldValueByType(
              FieldType.DATE_OF_BIRTH,
            );
            var gender = await results.textFieldValueByType(FieldType.SEX);
            var personalNumber = await results.textFieldValueByType(
              FieldType.PERSONAL_NUMBER,
            );
            var issueDate = await results.textFieldValueByType(
              FieldType.DATE_OF_ISSUE,
            );
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    name: name ?? "No Name",
                    nationality: nationality ?? "No Nationality Specified",
                    dateofbirth: dateofbirth ?? "No Date Of Birth Specified",
                    gender: gender ?? "No Gender Specified",
                    personalNumber:
                        personalNumber ?? "No Personal Number Specified",
                    issueDate: issueDate ?? "No Date of Issue specified",
                  ),
                ),
              );
            }
          }
        }
      },
    );
  }
}
