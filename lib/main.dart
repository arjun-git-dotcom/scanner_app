import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
import 'package:flutter_face_api/flutter_face_api.dart' hide InitConfig;
import 'package:scanning_app/cubit/sdkcubit.dart';
import 'package:scanning_app/cubit/sdkstate.dart';
import 'package:scanning_app/details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Sdkcubit()..initSDKs(),
      child: MaterialApp(home: Homepage()),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<void> scanDocument() async {
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
            if (mounted) {
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

  Future<void> checkLiveness() async {
    var response = await FaceSDK.instance.startLiveness();

    if (!mounted) return;
    if (response.image == null)  return;
    

    if (response.liveness == LivenessStatus.PASSED) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Identity verified successfully"),
          backgroundColor: Colors.green,
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Sdkcubit, SdkState>(
      listener: (context, state) {
        if (state is SdkError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: state is SdkInitial || state is SdkLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Initializing, please wait..."),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
      },
    );
  }
}
