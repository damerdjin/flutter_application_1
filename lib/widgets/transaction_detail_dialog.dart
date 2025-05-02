import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionDetailDialog extends StatefulWidget {
  final Transaction transaction;
  final Function(Transaction) onUpdate;

  const TransactionDetailDialog({
    super.key,
    required this.transaction,
    required this.onUpdate,
  });

  @override
  State<TransactionDetailDialog> createState() => _TransactionDetailDialogState();
}

class _TransactionDetailDialogState extends State<TransactionDetailDialog> {
  late TextEditingController _montantController;
  late TextEditingController _descriptionController;
  // Suppression du champ _isEditing qui n'est pas utilisé
  late String _categorie;
  late DateTime _date;
  late bool _estRevenu;

  @override
  void initState() {
    super.initState();
    _montantController = TextEditingController(text: widget.transaction.montant.toString());
    _descriptionController = TextEditingController(text: widget.transaction.description);
    _categorie = widget.transaction.titre;
    _date = widget.transaction.date;
    _estRevenu = widget.transaction.estRevenu;
  }

  @override
  void dispose() {
    _montantController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _afficherDialogueMotDePasse() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Entrez le mot de passe'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Mot de passe',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (passwordController.text == '0000') {
                Navigator.of(context).pop();
                _afficherFormulaireModification();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mot de passe incorrect'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _afficherFormulaireModification() {
    // Créer des copies locales pour le StatefulBuilder
    bool estRevenuLocal = _estRevenu;
    String categorieLocale = _categorie;
    DateTime dateLocale = _date;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
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
                    
                    // Boutons type de transaction
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setStateDialog(() {
                                estRevenuLocal = false;
                              });
                            },
                            icon: const Icon(Icons.arrow_downward),
                            label: const Text('Dépense'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !estRevenuLocal ? Colors.red : Colors.grey.shade200,
                              foregroundColor: !estRevenuLocal ? Colors.white : Colors.black,
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
                              setStateDialog(() {
                                estRevenuLocal = true;
                              });
                            },
                            icon: const Icon(Icons.arrow_upward),
                            label: const Text('Revenu'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: estRevenuLocal ? Colors.green : Colors.grey.shade200,
                              foregroundColor: estRevenuLocal ? Colors.white : Colors.black,
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
                        value: categorieLocale,
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
                            setStateDialog(() {
                              categorieLocale = newValue;
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
                          initialDate: dateLocale,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 365)), // Permettre les dates futures
                        );
                        if (pickedDate != null) {
                          setStateDialog(() {
                            dateLocale = pickedDate;
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
                              DateFormat('dd MMM yyyy').format(dateLocale),
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
                          // Remplacement de withOpacity par withAlpha
                          color: Colors.red.withAlpha(76), // 0.3 * 255 = 76
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
                    
                    // Bouton de sauvegarde
                    ElevatedButton(
                      onPressed: () {
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

                        final nouvelleTransaction = Transaction(
                          titre: categorieLocale,
                          montant: nouveauMontant,
                          date: dateLocale,
                          estRevenu: estRevenuLocal,
                          description: _descriptionController.text.trim(),
                        );

                        widget.onUpdate(nouvelleTransaction);
                        Navigator.of(context).pop(); // Ferme le dialogue de modification
                        Navigator.of(context).pop(); // Ferme le dialogue de détails
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Mettre à jour', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

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
                  widget.transaction.estRevenu ? 'Détails du revenu' : 'Détails de la dépense',
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
            _buildDetailRow('Catégorie:', widget.transaction.titre),
            _buildDetailRow(
              'Montant:',
              '${widget.transaction.montant.toStringAsFixed(2)} €',
              textColor: widget.transaction.estRevenu ? Colors.green : Colors.red,
            ),
            _buildDetailRow(
              'Date:',
              DateFormat('dd MMM yyyy').format(widget.transaction.date),
            ),
            _buildDetailRow('Description:', widget.transaction.description),
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
                  onPressed: _afficherDialogueMotDePasse,
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