// client_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collectiv/modules/collect-screen-module/models/client_response_model.dart';

final clientListProvider = StateProvider<List<ClientResponseModel>>((ref) {
  return []; // Initial empty list, we'll populate it later
});

final filteredClientsProvider = StateProvider<List<ClientResponseModel>>((ref) {
  return []; // Will hold filtered results
});

final searchQueryProvider = StateProvider<String>((ref) => '');
