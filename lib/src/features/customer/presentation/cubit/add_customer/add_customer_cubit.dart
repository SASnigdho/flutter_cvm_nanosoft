import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/customer.dart';
import '../../../data/repositories/customer_repository.dart';
import 'add_customer_state.dart';

@injectable
class AddCustomerCubit extends Cubit<AddCustomerState> {
  final CustomerRepository repository;

  AddCustomerCubit({required this.repository}) : super(AddCustomerInitial());

  Future<void> createCustomer(Customer customer) async {
    emit(AddCustomerLoading());
    try {
      await repository.createCustomerOffline(customer);
      emit(AddCustomerSuccess());
    } catch (e) {
      emit(AddCustomerError(e.toString()));
    }
  }
}
