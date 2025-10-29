import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? dob;
  final List<String> favProducts;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.dob,
    this.favProducts = const [],
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'favProducts': favProducts,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      dob: json['dob'],
      favProducts: List<String>.from(json['favProducts'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    dob,
    favProducts,
    createdAt,
  ];

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? dob,
    List<String>? favProducts,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      favProducts: favProducts ?? this.favProducts,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
