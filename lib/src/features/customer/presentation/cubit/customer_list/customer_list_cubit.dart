import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/customer.dart';
import '../../../data/repositories/customer_repository.dart';
import 'customer_list_state.dart';

@injectable
class CustomerListCubit extends Cubit<CustomerListState> {
  final CustomerRepository repository;

  CustomerListCubit({required this.repository}) : super(CustomerListInitial());

  Future<void> init() async {
    await repository.syncInitialData();
    await loadCustomers();
  }

  Future<void> loadCustomers() async {
    emit(CustomerListLoading());
    final result = await repository.getAllCustomers();

    result.fold((failure) => emit(CustomerListError(failure.message)), (
      customers,
    ) async {
      final pendingCount = await repository.getPendingSyncCount();
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult.contains(ConnectivityResult.none);

      emit(
        CustomerListLoaded(
          allCustomers: customers,
          filteredCustomers: customers,
          searchQuery: '',
          filterStatus: 'All',
          isOffline: isOffline,
          pendingSyncCount: pendingCount,
        ),
      );
    });
  }

  void searchCustomers(String query) {
    final currentState = state;
    if (currentState is CustomerListLoaded) {
      final filtered = currentState.allCustomers.where((customer) {
        return customer.name.toLowerCase().contains(query.toLowerCase()) ||
            customer.phone.contains(query);
      }).toList();

      emit(
        currentState.copyWith(searchQuery: query, filteredCustomers: filtered),
      );
    }
  }

  void filterByStatus(String status) {
    final currentState = state;
    if (currentState is CustomerListLoaded) {
      List<Customer> filtered;
      if (status == 'All') {
        filtered = currentState.allCustomers;
      } else {
        filtered = currentState.allCustomers
            .where((customer) => customer.visitStatus == status)
            .toList();
      }

      // Apply search filter on top of status filter
      if (currentState.searchQuery.isNotEmpty) {
        filtered = filtered.where((customer) {
          return customer.name.toLowerCase().contains(
                currentState.searchQuery.toLowerCase(),
              ) ||
              customer.phone.contains(currentState.searchQuery);
        }).toList();
      }

      emit(
        currentState.copyWith(
          filterStatus: status,
          filteredCustomers: filtered,
        ),
      );
    }
  }

  Future<void> syncNow() async {
    final currentState = state;
    if (currentState is CustomerListLoaded) {
      emit(CustomerListLoading());
      
      final pendingSyncResult = await repository.syncPendingOperations();
      
      pendingSyncResult.fold(
        (failure) => emit(CustomerListError('Pending sync failed: ${failure.message}')),
        (_) => null,
      );

      final initialSyncResult = await repository.syncInitialData();
      
      initialSyncResult.fold(
        (failure) => emit(CustomerListError('Initial sync failed: ${failure.message}')),
        (_) => null,
      );
      
      await loadCustomers();
    }
  }

  Future<void> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOffline = connectivityResult.contains(ConnectivityResult.none);

    if (state is CustomerListLoaded) {
      final currentState = state as CustomerListLoaded;
      if (currentState.isOffline != isOffline) {
        if (!isOffline) {
          await syncNow();
        } else {
          emit(currentState.copyWith(isOffline: isOffline));
        }
      }
    }
  }

  void updatePendingCount(int count) {
    if (state is CustomerListLoaded) {
      final currentState = state as CustomerListLoaded;
      emit(currentState.copyWith(pendingSyncCount: count));
    }
  }
}
