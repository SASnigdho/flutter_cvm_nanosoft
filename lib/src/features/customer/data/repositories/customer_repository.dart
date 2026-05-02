import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/database/sqf_lite_service.dart';
import '../../../../core/exceptions/failures.dart';
import '../models/customer.dart';
import '../models/pending_operation.dart';
import 'customer_remote_repository.dart';

@lazySingleton
class CustomerRepository {
  CustomerRepository({required this.dbService, required this.remoteRepository});

  final SqfLiteService dbService;
  final CustomerRemoteRepository remoteRepository;

  Future<Either<Failure, Unit>> syncInitialData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return left(const ConnectionFailure('No internet connection'));
    }

    try {
      final serverCustomers = await remoteRepository.fetchCustomers();
      final localCustomers = await dbService.getAllCustomers();

      for (final serverCustomer in serverCustomers) {
        final hasPending = await dbService.hasPendingOperationsForEntity(
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
            await dbService.insertCustomer(serverCustomer);
          } else {
            await dbService.updateCustomer(serverCustomer);
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
      final customers = await dbService.getAllCustomers();
      return right(customers);
    } catch (e) {
      log('DEV: $runtimeType: @getAllCustomers $e');
      return left(DatabaseFailure(e.toString()));
    }
  }

  Future<Either<Failure, Customer?>> getCustomerById(int id) async {
    try {
      final customer = await dbService.getCustomerById(id);
      return right(customer);
    } catch (e) {
      log('DEV: $runtimeType: @getCustomerById $e');
      return left(DatabaseFailure(e.toString()));
    }
  }

  Future<void> createCustomerOffline(Customer customer) async {
    final tempId = DateTime.now().millisecondsSinceEpoch;
    final newCustomer = customer.copyWith(id: tempId);

    await dbService.insertCustomer(newCustomer);

    final pendingOp = PendingOperation(
      entityType: 'customer',
      entityId: tempId,
      operationType: 'create',
      payload: json.encode(newCustomer.toJson()),
      createdAt: DateTime.now(),
    );

    await dbService.insertPendingOperation(pendingOp);
  }

  Future<void> updateCustomerOffline(Customer customer) async {
    await dbService.updateCustomer(customer);

    final existingPending = await dbService.hasPendingOperationsForEntity(
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

      await dbService.insertPendingOperation(pendingOp);
    }
  }

  Future<Either<Failure, Unit>> syncPendingOperations() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return left(const ConnectionFailure('No internet connection'));
    }

    try {
      final pendingOps = await dbService.getPendingOperations();

      for (final op in pendingOps) {
        try {
          if (op.operationType == 'create') {
            final customerData =
                json.decode(op.payload) as Map<String, dynamic>;
            customerData.remove('id');
            final customer = Customer.fromJson(customerData);
            final createdCustomer = await remoteRepository.createCustomer(
              customer,
            );

            await dbService.deleteCustomer(op.entityId);
            await dbService.insertCustomer(createdCustomer);
            await dbService.deletePendingOperation(op.id!);
          } else if (op.operationType == 'update') {
            final customer = Customer.fromJson(json.decode(op.payload));
            await remoteRepository.updateCustomer(customer);
            await dbService.deletePendingOperation(op.id!);
          }
        } catch (e) {
          final updatedOp = op.copyWith(
            retryCount: op.retryCount + 1,
            lastAttemptAt: DateTime.now(),
            status: op.retryCount + 1 >= 3 ? 'failed' : 'pending',
          );

          await dbService.updatePendingOperation(updatedOp);
        }
      }

      return right(unit);
    } catch (e) {
      log('Sync pending operations failed: $e');
      return left(ServerFailure(e.toString()));
    }
  }

  Future<int> getPendingSyncCount() async {
    return await dbService.getPendingOperationsCount();
  }

  Future<bool> hasPendingForCustomer(int customerId) async {
    return await dbService.hasPendingOperationsForEntity(
      'customer',
      customerId,
    );
  }
}
