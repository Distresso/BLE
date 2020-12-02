import 'package:distressoble/Model/UserModel.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'GroupModel.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class Group {
  final String groupName;
  final String groupNameId;
  final List<String> users;
  final int memberCount;

  Group({this.groupName, this.groupNameId, this.users,this.memberCount});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  Group copyWith({
    String groupName,
    String groupNameId,
    final List<String> users,
    int memberCount,
  }) {
    if ((groupName == null || identical(groupName, this.groupName)) && (users == null || identical(users, this.users)) && (groupNameId == null || identical(groupNameId, this.groupNameId)) && (memberCount == null || identical(memberCount, this.memberCount))) {
      return this;
    }

    return new Group(
      groupName: groupName ?? this.groupName,
      groupNameId: groupNameId ?? this.groupNameId,
      users: users ?? this.users,
      memberCount: memberCount ?? this.memberCount,
    );
  }
}