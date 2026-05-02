import 'package:injectable/injectable.dart';

import '../models/customer.dart';
import '../../../../core/network/dio_client.dart';

@lazySingleton
class CustomerRemoteRepository {
  final DioClient _dioClient;

  CustomerRemoteRepository(this._dioClient);

  Future<List<Customer>> fetchCustomers() async {
    final response = await _dioClient.get('/customers');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch customers');
    }
  }

  Future<Customer> createCustomer(Customer customer) async {
    final response = await _dioClient.post(
      '/customers',
      data: customer.toJson(),
    );
    if (response.statusCode == 201) {
      return Customer.fromJson(response.data);
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<Customer> updateCustomer(Customer customer) async {
    final response = await _dioClient.post(
      '/customers/${customer.id}',
      data: customer.toJson(),
    );
    if (response.statusCode == 200) {
      return Customer.fromJson(response.data);
    } else {
      throw Exception('Failed to update customer');
    }
  }
}
