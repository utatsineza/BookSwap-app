import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/swap_provider.dart';
import '../../providers/auth_provider.dart';
import 'chat_screen.dart';

class MyOffersScreen extends StatefulWidget {
  const MyOffersScreen({super.key});

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    final swap = context.read<SwapProvider>();
    if (auth.userId != null) {
      swap.listenToMyOffers(auth.userId!);
      swap.listenToReceivedOffers(auth.userId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final swap = context.watch<SwapProvider>();
    final auth = context.watch<AuthProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1a1a3e),
          foregroundColor: Colors.white,
          title: const Text('My Offers'),
          bottom: const TabBar(
            labelColor: Color(0xFFf4c542),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Sent'),
              Tab(text: 'Received'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSentOffers(swap, auth),
            _buildReceivedOffers(swap, auth),
          ],
        ),
      ),
    );
  }

  Widget _buildSentOffers(SwapProvider swap, AuthProvider auth) {
    if (swap.myOffers.isEmpty) {
      return const Center(child: Text('No sent offers'));
    }
    return ListView.builder(
      itemCount: swap.myOffers.length,
      itemBuilder: (context, index) {
        final offer = swap.myOffers[index];
        return ListTile(
          title: Text(offer.bookTitle),
          subtitle: Text('Status: ${offer.status.toString().split('.').last}'),
          trailing: offer.status == SwapStatus.accepted
              ? IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          otherUserId: offer.receiverId,
                          otherUserName: 'Receiver',
                        ),
                      ),
                    );
                  },
                )
              : null,
        );
      },
    );
  }

  Widget _buildReceivedOffers(SwapProvider swap, AuthProvider auth) {
    if (swap.receivedOffers.isEmpty) {
      return const Center(child: Text('No received offers'));
    }
    return ListView.builder(
      itemCount: swap.receivedOffers.length,
      itemBuilder: (context, index) {
        final offer = swap.receivedOffers[index];
        return ListTile(
          title: Text(offer.bookTitle),
          subtitle: Text('From: ${offer.senderName}'),
          trailing: offer.status == SwapStatus.pending
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        await swap.updateSwapStatus(offer.id, SwapStatus.accepted);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        await swap.updateSwapStatus(offer.id, SwapStatus.rejected);
                      },
                    ),
                  ],
                )
              : Text(offer.status.toString().split('.').last),
        );
      },
    );
  }
}
