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
    id: json['id'] ?? 0,
    password: json['password'] ?? '',
    remarks: json['remarks'] ?? '',
    userId: json['user_id'] ?? 0,
    deletedAt: json['deleted_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
    createdAt: json['created_at'] ?? '',
  );

  @override
  String toString() {
    return '''
    {
      "id": $id,
      "password": "$password",
      "remarks": "$remarks",
      "user_id": $userId,
      "deleted_at": "${deletedAt ?? ''}",
      "updated_at": "$updatedAt",
      "created_at": "$createdAt"
    }
    ''';
  }
}
