import 'package:json_annotation/json_annotation.dart';

part 'success_message.g.dart';

@JsonSerializable()
class SuccessMessage {
  String? status;
  String? message;

  SuccessMessage({this.status, this.message});

  factory SuccessMessage.fromJson(Map<String, dynamic> json) {
    return _$SuccessMessageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SuccessMessageToJson(this);
}
