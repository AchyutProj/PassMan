class Credential {
  int id;
  String name;
  String username;
  String password;
  String remarks;
  int userId;
  String createdAt;
  String updatedAt;

  Credential({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.remarks,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
    id: json['id'],
    name: json['name'],
    username: json['username'],
    password: json['password'],
    remarks: json['remarks'],
    userId: json['user_id'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}
