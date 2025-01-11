class Company {
  final int id;
  final String logo;
  final String companyName;
  final String companyNumber;
  final String companyAddress;

  Company({
    required this.id,
    required this.logo,
    required this.companyName,
    required this.companyNumber,
    required this.companyAddress,
  });

  // From JSON to Company object
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      logo: json['logo'],
      companyName: json['company_name'],
      companyNumber: json['company_number'],
      companyAddress: json['company_address'],
    );
  }

  // From Company object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logo': logo,
      'company_name': companyName,
      'company_number': companyNumber,
      'company_address': companyAddress,
    };
  }
}

