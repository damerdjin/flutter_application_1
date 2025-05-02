import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_detail_dialog.dart';

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
    final displayTransactions = recentOnly
        ? transactions.take(5).toList()
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
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => TransactionDetailDialog(
                  transaction: transaction,
                  onUpdate: (updatedTransaction) {
                    // Implémentation future de la mise à jour
                  },
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: transaction.estRevenu ? Colors.green[100] : Colors.red[100],
                child: Icon(
                  transaction.estRevenu ? Icons.arrow_upward : Icons.arrow_downward,
                  color: transaction.estRevenu ? Colors.green : Colors.red,
                ),
              ),
              title: Text(transaction.titre),
              subtitle: Text(transaction.description),
              trailing: Text(
                '${transaction.montant.toStringAsFixed(2)} €',
                style: TextStyle(
                  color: transaction.estRevenu ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}