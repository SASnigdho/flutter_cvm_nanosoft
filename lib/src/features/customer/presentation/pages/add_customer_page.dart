import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bindings/injection.dart';

import '../../data/models/customer.dart';
import '../cubit/add_customer/add_customer_cubit.dart';
import '../cubit/add_customer/add_customer_state.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddCustomerCubit>(),
      child: const AddCustomerView(),
    );
  }
}

class AddCustomerView extends StatefulWidget {
  const AddCustomerView({super.key});

  @override
  State<AddCustomerView> createState() => _AddCustomerViewState();
}

class _AddCustomerViewState extends State<AddCustomerView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _lastVisitDateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _lastVisitDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Customer')),
      body: BlocConsumer<AddCustomerCubit, AddCustomerState>(
        listener: (context, state) {
          if (state is AddCustomerSuccess) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Customer added offline - will sync when online'),
              ),
            );
          }
          if (state is AddCustomerError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  TextFormField(
                    controller: _lastVisitDateController,
                    decoration: const InputDecoration(
                      labelText: 'Last Visit Date (YYYY-MM-DD)',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is AddCustomerLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final customer = Customer(
                                name: _nameController.text,
                                phone: _phoneController.text,
                                email: _emailController.text,
                                address: _addressController.text,
                                lastVisitDate:
                                    _lastVisitDateController.text.isEmpty
                                    ? DateTime.now().toIso8601String().split(
                                        'T',
                                      )[0]
                                    : _lastVisitDateController.text,
                                visitStatus: 'Pending',
                                notes: '',
                              );
                              context.read<AddCustomerCubit>().createCustomer(
                                customer,
                              );
                            }
                          },
                    child: const Text('Add Customer'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
