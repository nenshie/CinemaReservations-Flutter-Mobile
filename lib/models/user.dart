class User {
  final String name;
  final String surname;
  final String email;
  final String jmbg;
  final String role;
  final String? password;
  final String? MobileNumber;

  User({
    required this.name,
    required this.surname,
    required this.email,
    required this.jmbg,
    required this.role,
    required this.MobileNumber,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      jmbg: json['jmbg'] ?? '',
      role: json['role'] ?? '',
      password: json['password'] ?? '',
      MobileNumber: json['MobileNumber']?.toString(),
    );
  }

  User copyWith({
    String? name,
    String? surname,
    String? email,
    String? jmbg,
    String? role,
    String? password,
    String? MobileNumber,
  }) {
    return User(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      jmbg: jmbg ?? this.jmbg,
      role: role ?? this.role,
      password: password ?? this.password,
      MobileNumber: MobileNumber ?? this.MobileNumber,
    );
  }
}
