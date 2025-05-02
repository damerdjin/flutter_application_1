import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final Function(String, double, bool) onAddTransaction;

  const TransactionForm({
    super.key,
    required this.onAddTransaction,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final formKey = GlobalKey<FormState>();
  String titre = '';
  String montant = '';
  bool estRevenu = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle transaction'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Titre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un titre';
                }
                return null;
              },
              onSaved: (value) {
                titre = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Montant (€)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un montant';
                }
                if (double.tryParse(value) == null) {
                  return 'Veuillez entrer un nombre valide';
                }
                return null;
              },
              onSaved: (value) {
                montant = value!;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Type: '),
                Radio<bool>(
                  value: true,
                  groupValue: estRevenu,
                  onChanged: (value) {
                    setState(() {
                      estRevenu = value!;
                    });
                  },
                ),
                const Text('Revenu'),
                Radio<bool>(
                  value: false,
                  groupValue: estRevenu,
                  onChanged: (value) {
                    setState(() {
                      estRevenu = value!;
                    });
                  },
                ),
                const Text('Dépense'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              widget.onAddTransaction(titre, double.parse(montant), estRevenu);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}