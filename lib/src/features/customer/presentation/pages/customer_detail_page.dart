import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bindings/injection.dart';
import '../cubit/customer_detail/customer_detail_cubit.dart';
import '../cubit/customer_detail/customer_detail_state.dart';
import '../widgets/customer_detail/status_dropdown.dart';

class CustomerDetailScreen extends StatelessWidget {
  final int customerId;

  const CustomerDetailScreen({
    super.key,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CustomerDetailCubit>(param1: customerId),
      child: const CustomerDetailView(),
    );
  }
}

class CustomerDetailView extends StatefulWidget {
  const CustomerDetailView({super.key});

  @override
  State<CustomerDetailView> createState() => _CustomerDetailViewState();
}

class _CustomerDetailViewState extends State<CustomerDetailView> {
  late TextEditingController _notesController;
  String _selectedStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Details')),
      body: BlocConsumer<CustomerDetailCubit, CustomerDetailState>(
        listener: (context, state) {
          if (state is CustomerDetailLoaded) {
            _notesController.text = state.customer.notes;
            _selectedStatus = state.customer.visitStatus;
          }
          if (state is CustomerDetailError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CustomerDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CustomerDetailLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.customer.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.phone,
                            'Phone',
                            state.customer.phone,
                          ),
                          _buildInfoRow(
                            Icons.email,
                            'Email',
                            state.customer.email,
                          ),
                          _buildInfoRow(
                            Icons.location_on,
                            'Address',
                            state.customer.address,
                          ),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Last Visit',
                            state.customer.lastVisitDate,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Visit Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          StatusDropdown(
                            value: _selectedStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _notesController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Notes',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final updatedCustomer = state.customer
                                        .copyWith(
                                          visitStatus: _selectedStatus,
                                          notes: _notesController.text,
                                        );
                                    await context
                                        .read<CustomerDetailCubit>()
                                        .updateCustomer(updatedCustomer);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Changes saved locally',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.save),
                                  label: const Text('Save Changes'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: state.hasPendingSync
                                  ? Colors.orange.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  state.hasPendingSync
                                      ? Icons.sync_problem
                                      : Icons.sync,
                                  color: state.hasPendingSync
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  state.hasPendingSync
                                      ? 'Pending Sync'
                                      : 'Synced',
                                  style: TextStyle(
                                    color: state.hasPendingSync
                                        ? Colors.orange
                                        : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Error loading customer'));
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
