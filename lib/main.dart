import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FinTrackHomePage(),
    );
  }
}

class FinTrackHomePage extends StatefulWidget {
  const FinTrackHomePage({super.key});

  @override
  State<FinTrackHomePage> createState() => _FinTrackHomePageState();
}

class _FinTrackHomePageState extends State<FinTrackHomePage> with SingleTickerProviderStateMixin {
  double soldeActuel = 0.0;
  double revenus = 0.0;
  double depenses = 0.0;
  List<Transaction> transactions = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _ajouterTransaction(String titre, double montant, bool estRevenu) {
    setState(() {
      final transaction = Transaction(
        titre: titre,
        montant: montant,
        date: DateTime.now(),
        estRevenu: estRevenu,
      );
      
      transactions.add(transaction);
      
      if (estRevenu) {
        revenus += montant;
        soldeActuel += montant;
      } else {
        depenses += montant;
        soldeActuel -= montant;
      }
    });
  }

  void _afficherDialogueAjoutTransaction() {
    final formKey = GlobalKey<FormState>();
    String titre = '';
    String montant = '';
    bool estRevenu = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                      _ajouterTransaction(titre, double.parse(montant), estRevenu);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('FinTrack'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Section du solde actuel
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Solde actuel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${soldeActuel.toStringAsFixed(2)} €',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Revenus',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${revenus.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dépenses',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${depenses.toStringAsFixed(2)} €',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Onglets pour les transactions
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Toutes'),
              Tab(text: 'Récentes'),
            ],
          ),
          
          // Liste des transactions
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Toutes les transactions
                transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Aucune transaction',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Appuyez sur + pour ajouter une nouvelle transaction',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: transaction.estRevenu
                                  ? Colors.green[100]
                                  : Colors.red[100],
                              child: Icon(
                                transaction.estRevenu
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: transaction.estRevenu
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            title: Text(transaction.titre),
                            subtitle: Text(
                              '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                            ),
                            trailing: Text(
                              '${transaction.estRevenu ? '+' : '-'}${transaction.montant.toStringAsFixed(2)} €',
                              style: TextStyle(
                                color: transaction.estRevenu
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                
                // Transactions récentes
                transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Aucune transaction récente',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: transactions.length > 5 ? 5 : transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[transactions.length - 1 - index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: transaction.estRevenu
                                  ? Colors.green[100]
                                  : Colors.red[100],
                              child: Icon(
                                transaction.estRevenu
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: transaction.estRevenu
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            title: Text(transaction.titre),
                            subtitle: Text(
                              '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                            ),
                            trailing: Text(
                              '${transaction.estRevenu ? '+' : '-'}${transaction.montant.toStringAsFixed(2)} €',
                              style: TextStyle(
                                color: transaction.estRevenu
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _afficherDialogueAjoutTransaction,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class Transaction {
  final String titre;
  final double montant;
  final DateTime date;
  final bool estRevenu;

  Transaction({
    required this.titre,
    required this.montant,
    required this.date,
    required this.estRevenu,
  });
}
