// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    groupName: json['groupName'] as String,
    groupNameId: json['groupNameId'] as String,
    users: (json['users'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    memberCount: json['memberCount'] as int,
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupName': instance.groupName,
      'groupNameId': instance.groupNameId,
      'users': instance.users?.map((e) => e?.toJson())?.toList(),
      'memberCount': instance.memberCount,
    };
