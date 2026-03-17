abstract class SdkState {}

class SdkInitial extends SdkState {}

class SdkLoading extends SdkState {}

class SdkReady extends SdkState {}

class SdkError extends SdkState {
  String message;
  SdkError(this.message);
}
