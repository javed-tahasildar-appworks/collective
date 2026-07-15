import 'package:collectiv/modules/collect-screen-module/provider/client_provider.dart';
import 'package:collectiv/modules/collect-screen-module/ui/collection_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collectiv/modules/collect-screen-module/models/client_response_model.dart';
import 'package:collectiv/utils/string_constants.dart';

class CollectScreen extends ConsumerWidget {
  const CollectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the client list once
    final clientList = ref.watch(clientListProvider);
    if (clientList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeClientData(ref);
      });
    }

    final filteredClients = ref.watch(filteredClientsProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchSection(ref, searchQuery),
            _buildStatsSection(filteredClients.length),
            Expanded(
              child: _buildClientList(context, filteredClients),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(WidgetRef ref, String searchQuery) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
            _filterClients(ref);
          },
          decoration: InputDecoration(
            hintText: 'Search clients by name or ID...',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.search_rounded,
                color: Colors.grey[500],
                size: 22,
              ),
            ),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear_rounded, color: Colors.grey[500]),
                    onPressed: () {
                      ref.read(searchQueryProvider.notifier).state = '';
                      _filterClients(ref);
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(int clientCount) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Clients',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$clientCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.people_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientList(
      BuildContext context, List<ClientResponseModel> clients) {
    if (clients.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              children: [
                const Text(
                  'Client List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${clients.length} Active',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: clients.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final client = clients[index];
                return _buildClientCard(context, client, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(
      BuildContext context, ClientResponseModel client, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(context, CollectionInput.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      client.clientPhoto,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getGradientColor(index)[0],
                                _getGradientColor(index)[1],
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              client.clientName.isNotEmpty
                                  ? client.clientName[0].toUpperCase()
                                  : 'C',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.clientName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        client.clientId,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            color: Color(0xFF3B82F6),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF667EEA),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No clients found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColor(int index) {
    final gradients = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFFFF6B6B), const Color(0xFFEE5A52)],
      [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
      [const Color(0xFFFFD93D), const Color(0xFFFF6B6B)],
      [const Color(0xFF6C5CE7), const Color(0xFFA29BFE)],
      [const Color(0xFF00B894), const Color(0xFF00CEC9)],
    ];
    return gradients[index % gradients.length];
  }

  void _filterClients(WidgetRef ref) {
    final query = ref.read(searchQueryProvider).toLowerCase();
    final clients = ref.read(clientListProvider);

    ref.read(filteredClientsProvider.notifier).state = clients.where((client) {
      final nameMatch = client.clientName.toLowerCase().contains(query);
      final idMatch = client.clientId.toLowerCase().contains(query);
      return nameMatch || idMatch;
    }).toList();
  }

  void _initializeClientData(WidgetRef ref) {
    final clientData = [
      ClientResponseModel(
          clientId: "#987654321",
          clientName: "John Doe",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#123456789",
          clientName: "Jane Smith",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#456789123",
          clientName: "Alice Johnson",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#789123456",
          clientName: "Bob Brown",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#321654987",
          clientName: "Charlie Davis",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#654321789",
          clientName: "Diana Evans",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#987123654",
          clientName: "Ethan Green",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#159753486",
          clientName: "Fiona Harris",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#753159852",
          clientName: "George King",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#951753486",
          clientName: "Hannah Lee",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#258963147",
          clientName: "Ian Miller",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#369258147",
          clientName: "Jack Nelson",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#147258369",
          clientName: "Kathy O'Brien",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#258147369",
          clientName: "Liam Parker",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#369147258",
          clientName: "Mia Roberts",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#147369258",
          clientName: "Noah Scott",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#258369147",
          clientName: "Olivia Taylor",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#369258147",
          clientName: "Paul Walker",
          clientPhoto: clientPhoto),
      ClientResponseModel(
          clientId: "#147258369",
          clientName: "Quinn Young",
          clientPhoto: clientPhoto),
    ];

    ref.read(clientListProvider.notifier).state = clientData;
    ref.read(filteredClientsProvider.notifier).state = clientData;
  }
}

// import 'package:collectiv/modules/collect-screen-module/provider/client_provider.dart';
// import 'package:collectiv/modules/collect-screen-module/ui/collection_input.dart';
// import 'package:collectiv/utils/search_bar_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:collectiv/modules/collect-screen-module/models/client_response_model.dart';
// import 'package:collectiv/utils/color_constants.dart';
// import 'package:collectiv/utils/string_constants.dart';

// class CollectScreen extends ConsumerWidget {
//   const CollectScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Initialize the client list once
//     final clientList = ref.watch(clientListProvider);
//     if (clientList.isEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ref.read(clientListProvider.notifier).state = [
//           ClientResponseModel(
//               clientId: "#987654321",
//               clientName: "John Doe",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#123456789",
//               clientName: "Jane Smith",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#456789123",
//               clientName: "Alice Johnson",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#789123456",
//               clientName: "Bob Brown",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#321654987",
//               clientName: "Charlie Davis",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#654321789",
//               clientName: "Diana Evans",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#987123654",
//               clientName: "Ethan Green",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#159753486",
//               clientName: "Fiona Harris",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#753159852",
//               clientName: "George King",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#951753486",
//               clientName: "Hannah Lee",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#258963147",
//               clientName: "Ian Miller",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#369258147",
//               clientName: "Jack Nelson",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#147258369",
//               clientName: "Kathy O'Brien",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#258147369",
//               clientName: "Liam Parker",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#369147258",
//               clientName: "Mia Roberts",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#147369258",
//               clientName: "Noah Scott",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#258369147",
//               clientName: "Olivia Taylor",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#369258147",
//               clientName: "Paul Walker",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#147258369",
//               clientName: "Quinn Young",
//               clientPhoto: clientPhoto),
//           // Add all your other clients here...
//         ];
//         ref.read(filteredClientsProvider.notifier).state = [
//           ClientResponseModel(
//               clientId: "#987654321",
//               clientName: "John Doe",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#123456789",
//               clientName: "Jane Smith",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#456789123",
//               clientName: "Alice Johnson",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#789123456",
//               clientName: "Bob Brown",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#321654987",
//               clientName: "Charlie Davis",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#654321789",
//               clientName: "Diana Evans",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#987123654",
//               clientName: "Ethan Green",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#159753486",
//               clientName: "Fiona Harris",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#753159852",
//               clientName: "George King",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#951753486",
//               clientName: "Hannah Lee",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#258963147",
//               clientName: "Ian Miller",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#369258147",
//               clientName: "Jack Nelson",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#147258369",
//               clientName: "Kathy O'Brien",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#258147369",
//               clientName: "Liam Parker",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#369147258",
//               clientName: "Mia Roberts",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#147369258",
//               clientName: "Noah Scott",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#258369147",
//               clientName: "Olivia Taylor",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#369258147",
//               clientName: "Paul Walker",
//               clientPhoto: clientPhoto),
//           ClientResponseModel(
//               clientId: "#147258369",
//               clientName: "Quinn Young",
//               clientPhoto: clientPhoto),
//         ];
//       });
//     }

//     final filteredClients = ref.watch(filteredClientsProvider);
//     ref.watch(searchQueryProvider);

//     return Scaffold(
//       backgroundColor: kWhite,
//       body: SafeArea(
//         child: Column(
//           children: [
//             SearchBarWidget(
//               onChanged: (value) {
//                 ref.read(searchQueryProvider.notifier).state = value;
//                 _filterClients(ref);
//               },
//             ),
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 itemCount: filteredClients.length,
//                 separatorBuilder: (context, index) => const Divider(
//                   height: 1,
//                   thickness: 1,
//                   indent: 72,
//                   endIndent: 16,
//                   color: Color(0xFFEEEEEE),
//                 ),
//                 itemBuilder: (context, index) {
//                   final client = filteredClients[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(8),
//                       leading: CircleAvatar(
//                         radius: 28,
//                         backgroundImage: NetworkImage(client.clientPhoto),
//                         backgroundColor: Colors.grey[200],
//                       ),
//                       title: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             client.clientId,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             client.clientName,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         Navigator.pushNamed(context, CollectionInput.routeName);
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _filterClients(WidgetRef ref) {
//     final query = ref.read(searchQueryProvider).toLowerCase();
//     final clients = ref.read(clientListProvider);

//     ref.read(filteredClientsProvider.notifier).state = clients.where((client) {
//       final nameMatch = client.clientName.toLowerCase().contains(query);
//       final idMatch = client.clientId.toLowerCase().contains(query);
//       return nameMatch || idMatch;
//     }).toList();
//   }
// }
