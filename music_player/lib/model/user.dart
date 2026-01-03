import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "age")
  int age;

  @JsonKey(name: "gender")
  bool gender;

  @JsonKey(name: "phoneNumber")
  String phoneNumber;

  @JsonKey(name: "address")
  String address;

  @JsonKey(name: "email")
  String email;

  @JsonKey(name: "password")
  String password;

  User({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
