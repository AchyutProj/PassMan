class GeneratedPassword {
  int id;
  String password;
  String remarks;
  int userId;
  String deletedAt;
  String updatedAt;
  String createdAt;

  GeneratedPassword({
    required this.id,
    required this.password,
    required this.remarks,
    required this.userId,
    required this.deletedAt,
    required this.updatedAt,
    required this.createdAt,
  });

  factory GeneratedPassword.fromJson(Map<String, dynamic> json) => GeneratedPassword(
    id: json['id'],
    password: json['password'],
    remarks: json['remarks'],
    userId: json['user_id'],
    deletedAt: json['deleted_at'],
    updatedAt: json['updated_at'],
    createdAt: json['created_at'],
  );
}
