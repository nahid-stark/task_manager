class EmailVerificationData {
  String? status;
  EmailVerificationData.fromJson(Map<String, dynamic> json){
    status = json["status"];
  }
}