import 'package:flutter/material.dart';

class PasswordDialog extends StatelessWidget {
  final Function onSuccess;
  final String password;

  const PasswordDialog({
    super.key,
    required this.onSuccess,
    this.password = '0000',
  });

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();

    return AlertDialog(
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
            if (passwordController.text == password) {
              Navigator.of(context).pop();
              onSuccess();
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
    );
  }
}