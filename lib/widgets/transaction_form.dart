import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? transaction;
  final Function(Transaction) onAddTransaction; // Renommé de onSubmit à onAddTransaction
  final String submitButtonText;

  const TransactionForm({
    super.key,
    this.transaction,
    required this.onAddTransaction, // Renommé ici aussi
    this.submitButtonText = 'Ajouter',
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  late TextEditingController _montantController;
  late TextEditingController _descriptionController;
  late String _categorie;
  late DateTime _date;
  late bool _estRevenu;

  @override
  void initState() {
    super.initState();
    // Initialiser avec les valeurs de la transaction existante ou des valeurs par défaut
    _montantController = TextEditingController(
      text: widget.transaction?.montant.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.transaction?.description ?? '',
    );
    _categorie = widget.transaction?.titre ?? 'Alimentation';
    _date = widget.transaction?.date ?? DateTime.now();
    _estRevenu = widget.transaction?.estRevenu ?? false;
  }

  @override
  void dispose() {
    _montantController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Boutons type de transaction
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _estRevenu = false;
                    });
                  },
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text('Dépense'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_estRevenu ? Colors.red : Colors.grey.shade200,
                    foregroundColor: !_estRevenu ? Colors.white : Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20),
                        right: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _estRevenu = true;
                    });
                  },
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Revenu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _estRevenu ? Colors.green : Colors.grey.shade200,
                    foregroundColor: _estRevenu ? Colors.white : Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(20),
                        right: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Champ montant
          const Text('Montant', style: TextStyle(fontSize: 14)),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _montantController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.euro),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Champ catégorie
          const Text('Catégorie', style: TextStyle(fontSize: 14)),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              value: _categorie,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              items: [
                'Alimentation',
                'Transport',
                'Divertissement',
                'Logement',
                'Loisirs',
                'Santé',
                'Éducation',
                'Autres'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _categorie = newValue;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          
          // Champ date
          const Text('Date', style: TextStyle(fontSize: 14)),
          GestureDetector(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (pickedDate != null) {
                setState(() {
                  _date = pickedDate;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('dd MMM yyyy').format(_date),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Champ description
          const Text('Description', style: TextStyle(fontSize: 14)),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.red.withAlpha(76),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.description, color: Colors.red),
                hintText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Bouton de soumission
          ElevatedButton(
            onPressed: _soumettreFormulaire,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(widget.submitButtonText, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _soumettreFormulaire() {
    final nouveauMontant = double.tryParse(_montantController.text.replaceAll(',', '.'));
    if (nouveauMontant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Montant invalide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer une description'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final transaction = Transaction(
      titre: _categorie,
      montant: nouveauMontant,
      date: _date,
      estRevenu: _estRevenu,
      description: _descriptionController.text.trim(),
    );

    widget.onAddTransaction(transaction);
    
    // Ne pas fermer la fenêtre ici, car cela sera géré par le parent
    // Supprimer cette ligne: Navigator.of(context).pop();
    
    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_estRevenu 
          ? 'Revenu ajouté avec succès' 
          : 'Dépense ajoutée avec succès'),
        backgroundColor: _estRevenu ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}