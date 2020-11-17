// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    groupId: json['groupId'] as String,
    uid: json['uid'] as String,
    age: json['age'] as num,
    currVital: json['currVital'] as num,
    gender: json['gender'] as String,
    height: json['height'] as num,
    lat: json['lat'] as num,
    lon: json['lon'] as num,
    name: json['name'] as String,
    surname: json['surname'] as String,
    weight: json['weight'] as num,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String,
    imageURL: json['imageURL'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'age': instance.age,
      'currVital': instance.currVital,
      'gender': instance.gender,
      'height': instance.height,
      'lat': instance.lat,
      'lon': instance.lon,
      'email': instance.email,
      'name': instance.name,
      'surname': instance.surname,
      'phoneNumber': instance.phoneNumber,
      'imageURL': instance.imageURL,
      'weight': instance.weight,
      'groupId': instance.groupId,
    };
