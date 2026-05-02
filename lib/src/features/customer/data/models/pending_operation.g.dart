// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingOperation _$PendingOperationFromJson(Map<String, dynamic> json) =>
    PendingOperation(
      id: (json['id'] as num?)?.toInt(),
      entityType: json['entityType'] as String,
      entityId: (json['entityId'] as num).toInt(),
      operationType: json['operationType'] as String,
      payload: json['payload'] as String,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAttemptAt: json['lastAttemptAt'] == null
          ? null
          : DateTime.parse(json['lastAttemptAt'] as String),
      status: json['status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$PendingOperationToJson(PendingOperation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'operationType': instance.operationType,
      'payload': instance.payload,
      'retryCount': instance.retryCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastAttemptAt': instance.lastAttemptAt?.toIso8601String(),
      'status': instance.status,
    };
