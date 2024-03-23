class SetNewPasswordData {
  String? status;
  SetNewPasswordData.fronJson(Map<String, dynamic> json) {
    status = json["status"];
  }
}