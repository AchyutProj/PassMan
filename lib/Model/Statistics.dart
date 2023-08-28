class Statistics {
  int credentials;
  int organizations;
  int generatedPasswords;

  Statistics({
    required this.credentials,
    required this.organizations,
    required this.generatedPasswords,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) => Statistics(
    credentials: json['credentials'] ?? 0,
    organizations: json['organizations'] ?? 0,
    generatedPasswords: json['generatedPasswords'] ?? 0,
  );

  @override
  String toString() {
    return '''
    {
      "credentials": $credentials,
      "organizations": $organizations,
      "generatedPasswords": $generatedPasswords
    }
    ''';
  }
}
