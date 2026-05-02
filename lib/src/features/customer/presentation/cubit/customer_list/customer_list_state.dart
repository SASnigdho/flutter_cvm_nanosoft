import 'package:equatable/equatable.dart';

import '../../../data/models/customer.dart';

abstract class CustomerListState extends Equatable {
  const CustomerListState();

  @override
  List<Object?> get props => [];
}

class CustomerListInitial extends CustomerListState {}

class CustomerListLoading extends CustomerListState {}

class CustomerListLoaded extends CustomerListState {
  final List<Customer> allCustomers;
  final List<Customer> filteredCustomers;
  final String searchQuery;
  final String filterStatus;
  final bool isOffline;
  final int pendingSyncCount;

  const CustomerListLoaded({
    required this.allCustomers,
    required this.filteredCustomers,
    required this.searchQuery,
    required this.filterStatus,
    required this.isOffline,
    required this.pendingSyncCount,
  });

  CustomerListLoaded copyWith({
    List<Customer>? allCustomers,
    List<Customer>? filteredCustomers,
    String? searchQuery,
    String? filterStatus,
    bool? isOffline,
    int? pendingSyncCount,
  }) {
    return CustomerListLoaded(
      allCustomers: allCustomers ?? this.allCustomers,
      filteredCustomers: filteredCustomers ?? this.filteredCustomers,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      isOffline: isOffline ?? this.isOffline,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
    );
  }

  @override
  List<Object?> get props => [
    allCustomers,
    filteredCustomers,
    searchQuery,
    filterStatus,
    isOffline,
    pendingSyncCount,
  ];
}

class CustomerListError extends CustomerListState {
  final String message;
  const CustomerListError(this.message);

  @override
  List<Object?> get props => [message];
}
