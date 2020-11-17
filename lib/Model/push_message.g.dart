// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushMessage _$PushMessageFromJson(Map<String, dynamic> json) {
  return PushMessage(
    id: json['id'] as int,
    title: json['title'] as String,
    message: json['message'] as String,
    date: json['date'] as String,
    read: json['read'] as String,
    delete: json['delete'] as String,
  );
}

Map<String, dynamic> _$PushMessageToJson(PushMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'date': instance.date,
      'read': instance.read,
      'delete': instance.delete,
    };
