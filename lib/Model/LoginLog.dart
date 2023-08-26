class LoginLog {
  final int id;
  final String userId;
  final String ipAddress;
  final String userAgent;
  final String firebaseUid;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  LoginLog({
    required this.id,
    required this.userId,
    required this.ipAddress,
    required this.userAgent,
    required this.firebaseUid,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoginLog.fromJson(Map<String, dynamic> json) {
    return LoginLog(
      id: json['id'],
      userId: json['user_id'],
      ipAddress: json['ip_address'],
      userAgent: json['user_agent'],
      firebaseUid: json['firebase_uid'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

List<LoginLog> parseLoginLogs(List<dynamic> jsonList) {
  return jsonList.map((json) => LoginLog.fromJson(json)).toList();
}