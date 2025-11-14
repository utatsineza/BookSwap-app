import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/swaps/swaps_bloc.dart';
import '../../blocs/swaps/swaps_event.dart';
import '../../blocs/swaps/swaps_state.dart';
import '../../models/swap.dart';

class SwapsTestScreen extends StatefulWidget {
  const SwapsTestScreen({Key? key}) : super(key: key);

  @override
  State<SwapsTestScreen> createState() => _SwapsTestScreenState();
}

class _SwapsTestScreenState extends State<SwapsTestScreen> {
  final _bookIdController = TextEditingController();
  final _recipientIdController = TextEditingController();
  final _statusController = TextEditingController();
  String _updateSwapId = '';

  @override
  void initState() {
    super.initState();
    // Load swaps when screen opens
    context.read<SwapsBloc>().add(LoadSwaps());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Swaps Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CREATE SWAP
            TextField(
              controller: _bookIdController,
              decoration: const InputDecoration(labelText: 'Book ID'),
            ),
            TextField(
              controller: _recipientIdController,
              decoration: const InputDecoration(labelText: 'Recipient ID'),
            ),
            ElevatedButton(
              onPressed: () {
                final bookId = _bookIdController.text.trim();
                final recipientId = _recipientIdController.text.trim();
                if (bookId.isNotEmpty && recipientId.isNotEmpty) {
                  context.read<SwapsBloc>().add(CreateSwapOffer(
                        bookId: bookId,
                        recipientId: recipientId,
                      ));
                  _bookIdController.clear();
                  _recipientIdController.clear();
                }
              },
              child: const Text('Create Swap'),
            ),
            const SizedBox(height: 20),

            // LIST SWAPS
            Expanded(
              child: BlocBuilder<SwapsBloc, SwapsState>(
                builder: (context, state) {
                  if (state is SwapsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SwapsLoaded) {
                    final swaps = state.swaps;
                    if (swaps.isEmpty) {
                      return const Center(child: Text('No swaps found.'));
                    }
                    return ListView.builder(
                      itemCount: swaps.length,
                      itemBuilder: (context, index) {
                        final swap = swaps[index];
                        return Card(
                          child: ListTile(
                            title: Text('Swap with ${swap.recipientId}'),
                            subtitle: Text('Book ID: ${swap.bookId}\nStatus: ${swap.status}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  _updateSwapId = swap.id;
                                  _statusController.text = swap.status;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is SwapsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),

            // UPDATE SWAP STATUS
            if (_updateSwapId.isNotEmpty) ...[
              TextField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'New Status'),
              ),
              ElevatedButton(
                onPressed: () {
                  final status = _statusController.text.trim();
                  if (status.isNotEmpty) {
                    context.read<SwapsBloc>().add(UpdateSwapStatus(
                          swapId: _updateSwapId,
                          status: status,
                        ));
                    setState(() {
                      _updateSwapId = '';
                      _statusController.clear();
                    });
                  }
                },
                child: const Text('Update Status'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
