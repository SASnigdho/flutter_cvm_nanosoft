import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer extends Equatable {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String address;
  @JsonKey(name: 'last_visit_date')
  final String lastVisitDate;
  @JsonKey(name: 'visit_status')
  final String visitStatus;
  final String notes;

  const Customer({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.lastVisitDate,
    required this.visitStatus,
    required this.notes,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? lastVisitDate,
    String? visitStatus,
    String? notes,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
      visitStatus: visitStatus ?? this.visitStatus,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, name, phone, email, address, lastVisitDate, visitStatus, notes];
}