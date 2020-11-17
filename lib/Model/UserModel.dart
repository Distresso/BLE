import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sp_user_repository/sp_user_repository.dart';

part 'UserModel.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class User {
  final String uid;
  final num age;
  final num currVital;
  final String gender;
  final num height;
  final num lat;
  final num lon;
  final String email;
  final String name;
  final String surname;
  final String phoneNumber;
  final String imageURL;
  final num weight;
  final String groupId;

  User({this.groupId, this.uid, this.age, this.currVital, this.gender, this.height, this.lat, this.lon, this.name, this.surname, this.weight, this.email, this.phoneNumber, this.imageURL});

  factory User.fromAuthProviderUserDetails(AuthProviderUserDetails authProviderUserDetails) => User(
        uid: authProviderUserDetails.id,
        name: authProviderUserDetails.name,
        surname: authProviderUserDetails.surname,
        email: authProviderUserDetails.email,
      );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String id,
    num age,
    num currVital,
    String gender,
    num height,
    num lat,
    num lon,
    String name,
    String surname,
    num weight,
    String email,
    String phoneNumber,
    String imageURL,
    String groupId,
  }) {
    if ((id == null || identical(id, this.uid)) && (age == null || identical(age, this.age)) && (currVital == null || identical(currVital, this.currVital)) && (gender == null || identical(gender, this.gender)) && (height == null || identical(height, this.height)) && (lat == null || identical(lat, this.lat)) && (lon == null || identical(lon, this.lon)) && (name == null || identical(name, this.name)) && (surname == null || identical(surname, this.surname)) && (weight == null || identical(weight, this.weight)) && (email == null || identical(email, this.email)) && (phoneNumber == null || identical(phoneNumber, this.phoneNumber)) && (imageURL == null || identical(imageURL, this.imageURL)) && (groupId == null || identical(groupId, this.groupId))) {
      return this;
    }

    return new User(
      uid: id ?? this.uid,
      age: age ?? this.age,
      currVital: currVital ?? this.currVital,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      weight: weight ?? this.weight,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageURL: imageURL ?? this.imageURL,
      groupId: groupId ?? this.groupId,
    );
  }
}
