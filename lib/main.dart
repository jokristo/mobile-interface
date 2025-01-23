import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CommandeForm(),
    );
  }
}

class CommandeForm extends StatefulWidget {
  @override
  _CommandeFormState createState() => _CommandeFormState();
}

class _CommandeFormState extends State<CommandeForm> {
  final TextEditingController bracerieController = TextEditingController();
  final TextEditingController depotController = TextEditingController();
  final TextEditingController quantiteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController typeProduitController = TextEditingController();

  Future<void> envoyerCommande() async {
    if (bracerieController.text.isEmpty ||
        depotController.text.isEmpty ||
        quantiteController.text.isEmpty ||
        dateController.text.isEmpty ||
        typeProduitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/api/client');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'bracerie': bracerieController.text,
        'article': depotController.text,
        'quantite': int.parse(quantiteController.text),
        'date': dateController.text,
        'typeProduit': typeProduitController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Commande envoyée avec succès !')),
      );
      bracerieController.clear();
      depotController.clear();
      quantiteController.clear();
      dateController.clear();
      typeProduitController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nouvelle Commande')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: bracerieController,
              decoration: InputDecoration(labelText: 'Nom bracerie'),
            ),
            TextField(
              controller: depotController,
              decoration: InputDecoration(labelText: 'Nom depot'),
            ),
            TextField(
              controller: quantiteController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantité'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: typeProduitController,
              decoration: InputDecoration(labelText: 'Type de produit'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: envoyerCommande,
              child: Text('Envoyer'),
            ),
          ],
        ),
      ),
    );
  }
}
