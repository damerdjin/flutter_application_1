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

  // Modifier cette méthode pour accepter un objet Transaction
  void _ajouterTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
      
      if (transaction.estRevenu) {
        revenus += transaction.montant;
        soldeActuel += transaction.montant;
      } else {
        depenses += transaction.montant;
        soldeActuel -= transaction.montant;
      }
    });
  }

  void _afficherDialogueAjoutTransaction() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
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
                      'Ajouter une transaction',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Formulaire de transaction
                TransactionForm(
                  onAddTransaction: (transaction) {
                    _ajouterTransaction(transaction);
                    Navigator.of(context).pop(); // Ferme la boîte de dialogue après l'ajout
                  },
                ),
              ],
            ),
          ),
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