class PasswordHistory {
  int id;
  String password;
  int userId;
  String createdAt;
  String updatedAt;

  PasswordHistory({
    required this.id,
    required this.password,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PasswordHistory.fromJson(Map<String, dynamic> json) => PasswordHistory(
    id: json['id'],
    password: json['password'],
    userId: json['user_id'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}
