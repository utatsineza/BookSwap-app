import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/swap_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/swap.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final swap = context.read<SwapProvider>();
      if (auth.userId != null) {
        swap.listenToMyOffers(auth.userId!);
        swap.listenToReceivedOffers(auth.userId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: const Color(0xFF1a1a3e),
          foregroundColor: Colors.white,
          title: const Text(
            'Swap Offers',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFFf4c542),
            unselectedLabelColor: Colors.white70,
            indicatorColor: Color(0xFFf4c542),
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: Icon(Icons.send),
                text: 'Sent',
              ),
              Tab(
                icon: Icon(Icons.inbox),
                text: 'Received',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSentOffers(),
            _buildReceivedOffers(),
          ],
        ),
      ),
    );
  }

  // SENT OFFERS TAB
  Widget _buildSentOffers() {
    return Consumer<SwapProvider>(
      builder: (context, swap, _) {
        if (swap.myOffers.isEmpty) {
          return _buildEmptyState(
            icon: Icons.send_outlined,
            title: 'No Sent Offers',
            message: 'Browse books and send swap offers to get started!',
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFf4c542),
          onRefresh: () async {
            final auth = context.read<AuthProvider>();
            if (auth.userId != null) {
              swap.listenToMyOffers(auth.userId!);
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: swap.myOffers.length,
            itemBuilder: (context, index) {
              final SwapOffer offer = swap.myOffers[index];
              return _buildSentOfferCard(offer);
            },
          ),
        );
      },
    );
  }

  // RECEIVED OFFERS TAB
  Widget _buildReceivedOffers() {
    return Consumer<SwapProvider>(
      builder: (context, swap, _) {
        if (swap.receivedOffers.isEmpty) {
          return _buildEmptyState(
            icon: Icons.inbox_outlined,
            title: 'No Received Offers',
            message: 'When someone wants to swap with your books, they\'ll appear here.',
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFf4c542),
          onRefresh: () async {
            final auth = context.read<AuthProvider>();
            if (auth.userId != null) {
              swap.listenToReceivedOffers(auth.userId!);
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: swap.receivedOffers.length,
            itemBuilder: (context, index) {
              final SwapOffer offer = swap.receivedOffers[index];
              return _buildReceivedOfferCard(offer);
            },
          ),
        );
      },
    );
  }

  // SENT OFFER CARD
  Widget _buildSentOfferCard(SwapOffer offer) {
    final statusColor = _getStatusColor(offer.status);
    final statusIcon = _getStatusIcon(offer.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  _getStatusText(offer.status),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(offer.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Offer Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.book, color: Color(0xFF1a1a3e), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        offer.bookTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a1a3e),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.grey[600], size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Sent to: ${offer.receiverId}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                // Action Button
                if (offer.status == SwapStatus.accepted) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              otherUserId: offer.receiverId,
                              otherUserName: 'Book Owner',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Start Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFf4c542),
                        foregroundColor: const Color(0xFF1a1a3e),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],

                if (offer.status == SwapStatus.rejected) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This offer was declined. Try another book!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // RECEIVED OFFER CARD
  Widget _buildReceivedOfferCard(SwapOffer offer) {
    final statusColor = _getStatusColor(offer.status);
    final isPending = offer.status == SwapStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isPending
            ? Border.all(color: const Color(0xFFf4c542), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPending
                  ? const Color(0xFFf4c542).withValues(alpha: 0.1)
                  : Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF1a1a3e),
                  child: Text(
                    offer.senderName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer.senderName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF1a1a3e),
                        ),
                      ),
                      Text(
                        _formatDate(offer.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isPending)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(offer.status),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Book Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.book, color: Color(0xFF1a1a3e), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        offer.bookTitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a1a3e),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Action Buttons for Pending Offers
                if (isPending) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final confirmed = await _showRejectDialog();
                            if (confirmed == true && mounted) {
                              await context.read<SwapProvider>().updateSwapStatus(
                                    offer.id,
                                    SwapStatus.rejected,
                                  );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Offer declined'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.close),
                          label: const Text('Decline'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final confirmed = await _showAcceptDialog(offer.bookTitle);
                            if (confirmed == true && mounted) {
                              await context.read<SwapProvider>().updateSwapStatus(
                                    offer.id,
                                    SwapStatus.accepted,
                                  );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Offer accepted! You can now chat.'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Chat Button for Accepted Offers
                if (offer.status == SwapStatus.accepted) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              otherUserId: offer.senderId,
                              otherUserName: offer.senderName,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: Text('Chat with ${offer.senderName}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFf4c542),
                        foregroundColor: const Color(0xFF1a1a3e),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DIALOGS
  Future<bool?> _showAcceptDialog(String bookTitle) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Offer?'),
        content: Text(
          'Accept this swap offer for "$bookTitle"? You\'ll be able to chat and arrange the exchange.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showRejectDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Offer?'),
        content: const Text('Are you sure you want to decline this swap offer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  // HELPERS
  Color _getStatusColor(SwapStatus status) {
    switch (status) {
      case SwapStatus.pending:
        return Colors.orange;
      case SwapStatus.accepted:
        return Colors.green;
      case SwapStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(SwapStatus status) {
    switch (status) {
      case SwapStatus.pending:
        return Icons.schedule;
      case SwapStatus.accepted:
        return Icons.check_circle;
      case SwapStatus.rejected:
        return Icons.cancel;
    }
  }

  String _getStatusText(SwapStatus status) {
    switch (status) {
      case SwapStatus.pending:
        return 'Waiting for response';
      case SwapStatus.accepted:
        return 'Accepted';
      case SwapStatus.rejected:
        return 'Declined';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}