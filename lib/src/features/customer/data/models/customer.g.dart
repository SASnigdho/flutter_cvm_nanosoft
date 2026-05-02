// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  // id: (json['id'] as num?)?.toInt(),
  id: int.parse((json['id'] as String?) ?? ''),
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  address: json['address'] as String,
  lastVisitDate: json['last_visit_date'] as String,
  visitStatus: json['visit_status'] as String,
  notes: json['notes'] as String,
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'last_visit_date': instance.lastVisitDate,
  'visit_status': instance.visitStatus,
  'notes': instance.notes,
};
