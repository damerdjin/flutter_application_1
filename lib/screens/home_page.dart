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
        return TransactionForm(
          onAddTransaction: _ajouterTransaction,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          'FinTrack',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.nightlight_round),
            onPressed: () {
              // Fonctionnalité future pour le mode sombre
            },
          ),
        ],
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(26), // Remplacé withOpacity(0.1) par withAlpha(26)
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.deepPurple,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.deepPurple,
              tabs: const [
                Tab(
                  icon: Icon(Icons.list_alt),
                  text: 'Toutes',
                ),
                Tab(
                  icon: Icon(Icons.access_time),
                  text: 'Récentes',
                ),
              ],
            ),
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
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}