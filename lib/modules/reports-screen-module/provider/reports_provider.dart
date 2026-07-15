import 'package:collectiv/modules/reports-screen-module/models/collection_transaction_response_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final collectionTransactionsListProvider =
    StateProvider<List<CollectionTransactionResponseModel>>((ref) {
  return []; // Initial empty list, we'll populate it later
});

final filteredCollectionTransactionsProvider =
    StateProvider<List<CollectionTransactionResponseModel>>((ref) {
  return []; // Will hold filtered results
});

final collectionTransactionsSearchQueryProvider =
    StateProvider<String>((ref) => '');
