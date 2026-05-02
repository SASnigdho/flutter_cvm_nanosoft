import 'package:equatable/equatable.dart';

abstract class AddCustomerState extends Equatable {
  const AddCustomerState();

  @override
  List<Object?> get props => [];
}

class AddCustomerInitial extends AddCustomerState {}

class AddCustomerLoading extends AddCustomerState {}

class AddCustomerSuccess extends AddCustomerState {}

class AddCustomerError extends AddCustomerState {
  final String message;
  const AddCustomerError(this.message);

  @override
  List<Object?> get props => [message];
}
