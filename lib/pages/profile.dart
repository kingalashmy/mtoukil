// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:suivi_stage2/sqldb.dart';

class EditProfileDialog extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileDialog({Key? key, required this.userData}) : super(key: key);

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.userData['nom_utilisateur']);
    _prenomController = TextEditingController(text: widget.userData['prenom_utilisateur']);
    _emailController = TextEditingController(text: widget.userData['email']);
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  SqlDb sqldb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Modifier le profil'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(controller: _nomController, decoration: InputDecoration(labelText: 'Nom', border: OutlineInputBorder()) ,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(controller: _prenomController, decoration: InputDecoration(labelText: 'Prénom', border: OutlineInputBorder())),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Annuler' , style: TextStyle(color: Colors.red),),
        ),
        ElevatedButton(
  onPressed: () async {
    // Construction de la requête SQL Update
    String sql = '''
  UPDATE Utilisateurs
  SET nom_utilisateur = '${_nomController.text}',
      prenom_utilisateur = '${_prenomController.text}',
      email = '${_emailController.text}'
  WHERE id = ${widget.userData['id']}
''';

    // Appel de la méthode updateData pour exécuter la requête SQL Update
    int response = await sqldb.updateData(sql);

    // Vérification de la réussite de la mise à jour
    if (response > 0) {
      // La mise à jour a réussi, affiche un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez vous déconnecter et vous reconnecter pour voir les modifications.'),
          backgroundColor: Colors.green,
        ),
      );

      // Ferme la boîte de dialogue
      Navigator.pop(context);
    } else {
      // La mise à jour a échoué, affiche un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la mise à jour des informations.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: Text('Enregistrer', style: TextStyle(color: Colors.green),),
),
      ],
    );
  }
}