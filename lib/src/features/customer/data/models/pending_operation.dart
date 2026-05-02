import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pending_operation.g.dart';

enum OperationType { create, update }

@JsonSerializable()
class PendingOperation extends Equatable {
  final int? id;
  final String entityType;
  final int entityId;
  final String operationType;
  final String payload;
  final int retryCount;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  final String status;

  const PendingOperation({
    this.id,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.payload,
    this.retryCount = 0,
    required this.createdAt,
    this.lastAttemptAt,
    this.status = 'pending',
  });

  factory PendingOperation.fromJson(Map<String, dynamic> json) => _$PendingOperationFromJson(json);
  Map<String, dynamic> toJson() => _$PendingOperationToJson(this);

  PendingOperation copyWith({
    int? id,
    String? entityType,
    int? entityId,
    String? operationType,
    String? payload,
    int? retryCount,
    DateTime? createdAt,
    DateTime? lastAttemptAt,
    String? status,
  }) {
    return PendingOperation(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, entityType, entityId, operationType, payload, retryCount, createdAt, lastAttemptAt, status];
}