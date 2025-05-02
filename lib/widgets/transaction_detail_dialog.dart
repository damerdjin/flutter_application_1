import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'password_dialog.dart';
import 'transaction_form.dart';

class TransactionDetailDialog extends StatelessWidget {
  final Transaction transaction;
  final Function(Transaction) onUpdate;

  const TransactionDetailDialog({
    super.key,
    required this.transaction,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.estRevenu ? 'Détails du revenu' : 'Détails de la dépense',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Catégorie:', transaction.titre),
            _buildDetailRow(
              'Montant:',
              '${transaction.montant.toStringAsFixed(2)} €',
              textColor: transaction.estRevenu ? Colors.green : Colors.red,
            ),
            _buildDetailRow(
              'Date:',
              DateFormat('dd MMM yyyy').format(transaction.date),
            ),
            _buildDetailRow('Description:', transaction.description),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fermer'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _afficherDialogueMotDePasse(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Modifier'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _afficherDialogueMotDePasse(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PasswordDialog(
        onSuccess: () => _afficherFormulaireModification(context),
      ),
    );
  }

  void _afficherFormulaireModification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête avec bouton de fermeture
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Modifier la transaction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 16),
              
              // Formulaire de transaction réutilisable
              TransactionForm(
                transaction: transaction,
                submitButtonText: 'Mettre à jour',
                // Remplacer onSubmit par onAddTransaction
                onAddTransaction: (nouvelleTransaction) {
                  onUpdate(nouvelleTransaction);
                  Navigator.of(context).pop(); // Ferme le dialogue de modification
                  Navigator.of(context).pop(); // Ferme le dialogue de détails
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}