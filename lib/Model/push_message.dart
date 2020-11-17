import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'push_message.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class PushMessage extends Equatable {
  final int id;
  final String title;
  final String message;
  final String date;
  final String read;
  final String delete;

  PushMessage({this.id, this.title, this.message, this.date, this.read, this.delete});

  @override
  List<Object> get props => [id, title, message, date, read, delete];

  factory PushMessage.fromJson(Map<String, dynamic> json) => _$PushMessageFromJson(json);

  Map<String, dynamic> toJson() => _$PushMessageToJson(this);

  @override
  String toString() {
    return '$id, $title, $message, $date, $read, $delete';
  }

  PushMessage copyWith(PushMessage newVal) {
    return PushMessage(
      id: newVal.id ?? id,
      read: newVal.read ?? read,
      delete: newVal.delete ?? delete,
      date: newVal.date ?? date,
      message: newVal.message ?? message,
      title: newVal.title ?? title,
    );
  }
}
