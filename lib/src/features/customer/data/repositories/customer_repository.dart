import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/sqf_lite_service.dart';
import '../../../../core/exceptions/failures.dart';
import 'customer_remote_repository.dart';
import '../models/customer.dart';
import '../models/pending_operation.dart';

@lazySingleton
class CustomerRepository {
  CustomerRepository({required this.dbHelper, required this.apiClient});

  final SqfLiteService dbHelper;
  final CustomerRemoteRepository apiClient;

  Future<Either<Failure, Unit>> syncInitialData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return left(const ConnectionFailure('No internet connection'));
    }

    try {
      final serverCustomers = await apiClient.fetchCustomers();
      final localCustomers = await dbHelper.getAllCustomers();

      for (final serverCustomer in serverCustomers) {
        final hasPending = await dbHelper.hasPendingOperationsForEntity(
          'customer',
          serverCustomer.id!,
        );

        if (!hasPending) {
          final existingLocal = localCustomers.firstWhere(
            (local) => local.id == serverCustomer.id,
            orElse: () => const Customer(
              id: -1,
              name: '',
              phone: '',
              email: '',
              address: '',
              lastVisitDate: '',
              visitStatus: '',
              notes: '',
            ),
          );

          if (existingLocal.id == -1) {
            await dbHelper.insertCustomer(serverCustomer);
          } else {
            await dbHelper.updateCustomer(serverCustomer);
          }
        }
      }

      return right(unit);
    } catch (e) {
      log('Initial sync failed: $e');
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<Customer>>> getAllCustomers() async {
    try {
      final customers = await dbHelper.getAllCustomers();
      return right(customers);
    } catch (e) {
      log('DEV: $runtimeType: @getAllCustomers $e');
      return left(DatabaseFailure(e.toString()));
    }
  }

  Future<Either<Failure, Customer?>> getCustomerById(int id) async {
    try {
      final customer = await dbHelper.getCustomerById(id);
      return right(customer);
    } catch (e) {
      log('DEV: $runtimeType: @getCustomerById $e');
      return left(DatabaseFailure(e.toString()));
    }
  }

  Future<void> createCustomerOffline(Customer customer) async {
    final tempId = DateTime.now().millisecondsSinceEpoch;
    final newCustomer = customer.copyWith(id: tempId);

    await dbHelper.insertCustomer(newCustomer);

    final pendingOp = PendingOperation(
      entityType: 'customer',
      entityId: tempId,
      operationType: 'create',
      payload: json.encode(newCustomer.toJson()),
      createdAt: DateTime.now(),
    );

    await dbHelper.insertPendingOperation(pendingOp);
  }

  Future<void> updateCustomerOffline(Customer customer) async {
    await dbHelper.updateCustomer(customer);

    final existingPending = await dbHelper.hasPendingOperationsForEntity(
      'customer',
      customer.id!,
    );

    if (!existingPending) {
      final pendingOp = PendingOperation(
        entityType: 'customer',
        entityId: customer.id!,
        operationType: 'update',
        payload: json.encode(customer.toJson()),
        createdAt: DateTime.now(),
      );
      await dbHelper.insertPendingOperation(pendingOp);
    }
  }

  Future<Either<Failure, Unit>> syncPendingOperations() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return left(const ConnectionFailure('No internet connection'));
    }

    try {
      final pendingOps = await dbHelper.getPendingOperations();

      for (final op in pendingOps) {
        try {
          if (op.operationType == 'create') {
            final customerData =
                json.decode(op.payload) as Map<String, dynamic>;
            customerData.remove('id');
            final customer = Customer.fromJson(customerData);
            final createdCustomer = await apiClient.createCustomer(customer);

            await dbHelper.deleteCustomer(op.entityId);
            await dbHelper.insertCustomer(createdCustomer);
            await dbHelper.deletePendingOperation(op.id!);
          } else if (op.operationType == 'update') {
            final customer = Customer.fromJson(json.decode(op.payload));
            await apiClient.updateCustomer(customer);
            await dbHelper.deletePendingOperation(op.id!);
          }
        } catch (e) {
          final updatedOp = op.copyWith(
            retryCount: op.retryCount + 1,
            lastAttemptAt: DateTime.now(),
            status: op.retryCount + 1 >= 3 ? 'failed' : 'pending',
          );
          await dbHelper.updatePendingOperation(updatedOp);
        }
      }
      return right(unit);
    } catch (e) {
      log('Sync pending operations failed: $e');
      return left(ServerFailure(e.toString()));
    }
  }

  Future<int> getPendingSyncCount() async {
    return await dbHelper.getPendingOperationsCount();
  }

  Future<bool> hasPendingForCustomer(int customerId) async {
    return await dbHelper.hasPendingOperationsForEntity('customer', customerId);
  }
}
