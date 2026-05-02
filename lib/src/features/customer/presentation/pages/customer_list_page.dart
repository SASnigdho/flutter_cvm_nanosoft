import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/bindings/injection.dart';
import 'add_customer_page.dart';
import 'customer_detail_page.dart';
import '../cubit/customer_list/customer_list_cubit.dart';
import '../cubit/customer_list/customer_list_state.dart';
import '../widgets/customer_card.dart';
import '../widgets/filter_chip_row.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final _cubit = getIt<CustomerListCubit>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((result) {
      _cubit.checkConnectivity();
    });

    _cubit.init();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Visits'),
        actions: [
          BlocBuilder<CustomerListCubit, CustomerListState>(
            bloc: _cubit,
            builder: (context, state) {
              if (state is CustomerListLoaded && state.pendingSyncCount > 0) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.sync),
                      onPressed: () => _cubit.syncNow(),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${state.pendingSyncCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () => _cubit.syncNow(),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CustomerListCubit, CustomerListState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state is CustomerListError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CustomerListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CustomerListLoaded) {
            return Column(
              children: [
                if (state.isOffline)
                  Container(
                    width: double.infinity,
                    color: Colors.orange,
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      children: [
                        Icon(Icons.wifi_off, size: 20),
                        SizedBox(width: 8),
                        Text('Offline Mode - Changes will sync when online'),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search by name or phone',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: _cubit.searchCustomers,
                      ),
                      const SizedBox(height: 12),
                      FilterChipRow(
                        selectedStatus: state.filterStatus,
                        onStatusSelected: _cubit.filterByStatus,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.filteredCustomers.isEmpty
                      ? const Center(child: Text('No customers found'))
                      : ListView.builder(
                          itemCount: state.filteredCustomers.length,
                          itemBuilder: (context, index) {
                            final customer = state.filteredCustomers[index];

                            return CustomerCard(
                              customer: customer,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomerDetailScreen(
                                      customerId: customer.id!,
                                    ),
                                  ),
                                );
                                _cubit.loadCustomers();
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const Center(child: Text('No data'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCustomerScreen()),
          );

          if (result == true) _cubit.loadCustomers();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
