import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_reader_api/flutter_document_reader_api.dart';
import 'package:flutter_face_api/flutter_face_api.dart' hide InitConfig;
import 'package:scanning_app/cubit/sdkstate.dart';

class Sdkcubit extends Cubit<SdkState> {
  Sdkcubit() : super(SdkInitial());

  Future<void> initSDKs() async {
    emit(SdkLoading());
const errorMessage = "Something went wrong. Please restart the app";
    try {
      ByteData license = await rootBundle.load("assets/regula.license");
      var config = InitConfig(license);
      
      var (success, error) = await DocumentReader.instance.initialize(config);
      if (!success) {
        emit(SdkError(errorMessage));
      }

      var (faceSuccess, faceError) = await FaceSDK.instance.initialize();
      if (!faceSuccess) {
        emit(SdkError(errorMessage));
        return;
      }
      emit(SdkReady());
    } catch (e) {
      emit(SdkError(errorMessage));
    }
  }
}
