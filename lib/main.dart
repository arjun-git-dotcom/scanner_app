import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanning_app/cubit/sdkcubit.dart';
import 'package:scanning_app/cubit/sdkstate.dart';
import 'package:scanning_app/widgets/check_liveness_widget.dart';
import 'package:scanning_app/widgets/scan_document_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => Sdkcubit()..initSDKs(),
      child: const MaterialApp(home: Homepage()),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late ScanDocumentWidget scanDocument;
  late CheckLivenessWidget liveness;

  @override
  void initState() {
    super.initState();
    scanDocument = ScanDocumentWidget(context: context);
    liveness = CheckLivenessWidget(context: context);
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
                ? const Column(
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
                          scanDocument.scanDocument();
                        },
                        child: const Text("Scan Passport/ID"),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          liveness.checkLiveness();
                        },
                        child: const Text("liveness check"),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
