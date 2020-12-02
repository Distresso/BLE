// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    groupName: json['groupName'] as String,
    groupNameId: json['groupNameId'] as String,
    users: (json['users'] as List)?.map((e) => e as String)?.toList(),
    memberCount: json['memberCount'] as int,
  );
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupName': instance.groupName,
      'groupNameId': instance.groupNameId,
      'users': instance.users,
      'memberCount': instance.memberCount,
    };
