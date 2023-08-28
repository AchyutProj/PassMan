class Organization {
  int id;
  String name;
  String email;
  String website;
  String phoneNumber;
  String remarks;
  String deletedAt;
  String createdAt;
  String updatedAt;

  Organization({
    required this.id,
    required this.name,
    required this.email,
    required this.website,
    required this.phoneNumber,
    required this.remarks,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    website: json['website'] ?? '',
    phoneNumber: json['phone_number'] ?? '',
    remarks: json['remarks'] ?? '',
    deletedAt: json['deleted_at'] ?? '',
    createdAt: json['created_at'] ?? '',
    updatedAt: json['updated_at'] ?? '',
  );

  @override
  String toString() {
    return '''
    {
      "id": $id,
      "name": ${name},
      "email": ${email},
      "website": ${website},
      "phone_number": ${phoneNumber},
      "remarks": ${remarks ?? ''},
      "deleted_at": "${deletedAt ?? ''}",
      "created_at": "${createdAt}",
      "updated_at": "${updatedAt}"
    }
    ''';
  }
}
