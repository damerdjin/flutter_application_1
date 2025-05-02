import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_form.dart';
import '../widgets/transaction_list.dart';

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
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return TransactionForm(
              onAddTransaction: _ajouterTransaction,
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
          BalanceCard(
            soldeActuel: soldeActuel,
            revenus: revenus,
            depenses: depenses,
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
                TransactionList(
                  transactions: transactions,
                ),
                
                // Transactions récentes
                TransactionList(
                  transactions: transactions,
                  recentOnly: true,
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