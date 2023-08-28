class Credential {
  int id;
  String name;
  String url;
  String username;
  String password;
  String remarks;
  String userId;
  String createdAt;
  String updatedAt;
  CredUser user;

  Credential({
    required this.id,
    required this.name,
    required this.url,
    required this.username,
    required this.password,
    required this.remarks,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Credential.fromJson(Map<String, dynamic> json) => Credential(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    url: json['url'] ?? '',
    username: json['username'] ?? '',
    password: json['password'] ?? '',
    remarks: json['remarks'] ?? '',
    userId: json['user_id'] ?? '',
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
    user: json['user'] != null ? CredUser.fromJson(json['user']) : CredUser.fromJson({}),
  );

  @override
  String toString() {
    return '''
    {
      "id": $id,
      "name": ${name ?? ''},
      "url": ${url ?? ''},
      "username": ${username ?? ''},
      "password": ${password ?? ''},
      "remarks": ${remarks ?? ''},
      "user_id": ${userId ?? ''},
      "created_at": "${createdAt ?? ''}",
      "updated_at": "${updatedAt ?? ''}",
      "user": ${user != null ? user.toString() : {}}    }
    ''';
  }
}

class CredUser {
  int id;
  String firstName;
  String middleName;
  String lastName;

  CredUser({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  factory CredUser.fromJson(Map<String, dynamic> json) => CredUser(
    id: json['id'],
    firstName: json['first_name'],
    middleName: json['middle_name'] ?? '',
    lastName: json['last_name'],
  );

  @override
  String toString() {
    return '''
    {
      "id": $id,
      "first_name": ${firstName},
      "middle_name": ${middleName ?? ''},
      "last_name": ${lastName}
    }
    ''';
  }
}
