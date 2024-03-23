class OtpVerificationData {
  String? status;
  OtpVerificationData.fronJson(Map<String, dynamic> json) {
    status = json["status"];
  }
}