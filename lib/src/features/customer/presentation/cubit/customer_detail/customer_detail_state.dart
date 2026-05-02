import 'package:equatable/equatable.dart';

import '../../../data/models/customer.dart';

abstract class CustomerDetailState extends Equatable {
  const CustomerDetailState();

  @override
  List<Object?> get props => [];
}

class CustomerDetailLoading extends CustomerDetailState {}

class CustomerDetailLoaded extends CustomerDetailState {
  final Customer customer;
  final bool hasPendingSync;

  const CustomerDetailLoaded({
    required this.customer,
    required this.hasPendingSync,
  });

  @override
  List<Object?> get props => [customer, hasPendingSync];
}

class CustomerDetailError extends CustomerDetailState {
  final String message;
  const CustomerDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
