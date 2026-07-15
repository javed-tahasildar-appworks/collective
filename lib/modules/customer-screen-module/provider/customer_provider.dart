// client_provider.dart
import 'package:collectiv/modules/customer-screen-module/models/customer_response_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerListProvider = StateProvider<List<CustomerResponseModel>>((ref) {
  return []; // Initial empty list, we'll populate it later
});

final filteredCustomerProvider =
    StateProvider<List<CustomerResponseModel>>((ref) {
  return []; // Will hold filtered results
});

final searchQueryProvider = StateProvider<String>((ref) => '');
