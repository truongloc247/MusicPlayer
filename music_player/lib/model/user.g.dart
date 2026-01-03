// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  gender: json['gender'] as bool,
  phoneNumber: json['phoneNumber'] as String,
  address: json['address'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'age': instance.age,
  'gender': instance.gender,
  'phoneNumber': instance.phoneNumber,
  'address': instance.address,
  'email': instance.email,
  'password': instance.password,
};
