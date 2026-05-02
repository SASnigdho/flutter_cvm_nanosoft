import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/customer.dart';
import '../../../data/repositories/customer_repository.dart';
import 'customer_detail_state.dart';

@injectable
class CustomerDetailCubit extends Cubit<CustomerDetailState> {
  final CustomerRepository repository;
  final int customerId;

  CustomerDetailCubit(this.repository, @factoryParam this.customerId)
    : super(CustomerDetailLoading()) {
    loadCustomer();
  }

  Future<void> loadCustomer() async {
    emit(CustomerDetailLoading());
    final result = await repository.getCustomerById(customerId);

    result.fold((failure) => emit(CustomerDetailError(failure.message)), (
      customer,
    ) async {
      if (customer != null) {
        final hasPending = await repository.hasPendingForCustomer(customerId);
        emit(
          CustomerDetailLoaded(customer: customer, hasPendingSync: hasPending),
        );
      } else {
        emit(CustomerDetailError('Customer not found'));
      }
    });
  }

  Future<void> updateCustomer(Customer updatedCustomer) async {
    try {
      emit(CustomerDetailLoading());
      await repository.updateCustomerOffline(updatedCustomer);
      await loadCustomer();
    } catch (e) {
      emit(CustomerDetailError(e.toString()));
    }
  }
}
