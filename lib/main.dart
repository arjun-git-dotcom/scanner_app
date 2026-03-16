import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
import 'package:flutter_face_api/flutter_face_api.dart' hide InitConfig;
import 'package:scanning_app/details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Homepage());
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DocumentReader documentReader = DocumentReader.instance;
  FaceSDK faceSDK = FaceSDK.instance;
  String result = "scan press";

  @override
  void initState() {
    super.initState();
    initSDKs();
  }

  Future<void> initSDKs() async {
    try {
      ByteData license = await rootBundle.load("assets/regula.license");
      var config = InitConfig(license);
      var (success, error) = await documentReader.initialize(config);
      if (!success) {
        setState(() => result = "Doc Reader failed: ${error?.message}");
        return;
      }
    } catch (e) {
      setState(() => result = "exception: $e");
      return;
    }

    var (faceSuccess, faceError) = await faceSDK.initialize();
    if (!faceSuccess) {
      setState(() => result = "Face SDK failed: ${faceError?.message}");
      return;
    }

    setState(() => result = "ready - press scan");
  }

  Future<void> scanDocument() async {
    documentReader.startScanner(ScannerConfig.withScenario(Scenario.MRZ), (
      action,
      results,
      error,
    ) async {
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
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsPage(name: name??"no name",nationality: nationality??"no nationality specified",dateofbirth: dateofbirth??"no date of birth specified",)),
            );
          }
        }
      }
    });
  }

  Future<void> checkLiveness() async {
    var faceApi = FaceSDK.instance;

    var response = await faceApi.startLiveness();

    if (response.liveness == LivenessStatus.PASSED) {
      setState(() => result = " Real person detected");
    } else {
      setState(() => result = " Liveness failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result),
            ElevatedButton(
              onPressed: () {
                scanDocument();
              },
              child: Text("Scan Passport/ID"),
            ),

            ElevatedButton(
              onPressed: () {
                checkLiveness();
              },
              child: Text("liveness check"),
            ),
          ],
        ),
      ),
    );
  }
}
