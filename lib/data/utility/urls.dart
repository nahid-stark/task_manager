class Urls {
  static const String _baseUrl = "https://task.teamrabbil.com/api/v1";
  static const String registration = "$_baseUrl/registration";
  static const String login = "$_baseUrl/login";
  static const String createTask = "$_baseUrl/createTask";
  static const String taskCountByStatus = "$_baseUrl/taskStatusCount";
  static const String newTaskList = "$_baseUrl/listTaskByStatus/New";
  static const String completedTaskList = "$_baseUrl/listTaskByStatus/Completed";
  static const String cancelledTaskList = "$_baseUrl/listTaskByStatus/Cancelled";
  static const String progressTaskList = "$_baseUrl/listTaskByStatus/Progress";
  static const String profileUpdate = "$_baseUrl/profileUpdate";
  static String deleteTask(String id) => "$_baseUrl/deleteTask/$id";
  static String emailOfPasswordRecoveryProcess(String email) => "$_baseUrl/RecoverVerifyEmail/$email";
  static String otpOfPasswordRecoveryProcess(String email, String otp) => "$_baseUrl/RecoverVerifyOTP/$email/$otp";
  static String setNewPassword = "$_baseUrl/RecoverResetPass";
  static String updateTaskStatus(String id, String status) => "$_baseUrl/updateTaskStatus/$id/$status";
}