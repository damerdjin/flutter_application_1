import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final bool recentOnly;

  const TransactionList({
    super.key,
    required this.transactions,
    this.recentOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              recentOnly ? 'Aucune transaction récente' : 'Aucune transaction',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            if (!recentOnly)
              const SizedBox(height: 8),
            if (!recentOnly)
              const Text(
                'Appuyez sur + pour ajouter une nouvelle transaction',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      );
    }

    final displayTransactions = recentOnly
        ? transactions.length > 5
            ? transactions.sublist(transactions.length - 5)
            : transactions
        : transactions;

    return ListView.builder(
      itemCount: displayTransactions.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final transaction = recentOnly
            ? displayTransactions[displayTransactions.length - 1 - index]
            : displayTransactions[index];
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: transaction.estRevenu
                  ? Colors.green[50]
                  : Colors.red[50],
              child: Icon(
                transaction.estRevenu
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: transaction.estRevenu
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            title: Text(
              transaction.titre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 12,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: Text(
              '${transaction.estRevenu ? '+' : '-'}${transaction.montant.toStringAsFixed(2)} €',
              style: TextStyle(
                color: transaction.estRevenu
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}