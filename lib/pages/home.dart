// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:suivi_stage2/pages/ListStage.dart';
import 'package:suivi_stage2/pages/Missions.dart';
// import 'package:suivi_stage2/pages/Objectifs.dart';
import 'package:suivi_stage2/pages/Realisations.dart';
import 'package:suivi_stage2/pages/profile.dart';


class HomePage extends StatelessWidget {
  final Map<String, dynamic> userData;
  // ignore: use_super_parameters
  const HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: const Text(
          'Accueil',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.home,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //profile
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                title: Text(
                  'Profil',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileDialog(userData: userData),
                    ),
                  );
                },
              ),
            ),

            //liste de stages
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                leading: Icon(Icons.list, color: Colors.blue),
                title: Text(
                  'Listes de Stages',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListStage(
                        userData: userData,
                      ),
                    ),
                  );
                },
              ),
            ),
            //Les missions
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                leading: Icon(
                  Icons.task,
                  color: Colors.blue,
                ),
                title: Text(
                  'Les Missions',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Missions(
                        stageId: 1 /* Valeur de stageId */,
                        isProfesseur: true  ,
                        // * Valeur de isProfesseur */,
                      ),
                    ),
                      
                  );
                },
              ),
            ),
            //Les objectifes

            //Les Realisations
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListTile(
                leading: Icon(Icons.done, color: Colors.blue),
                title: Text(
                  'Les Realisations',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Realisations(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("lib/images/testHomeImg.png",
                    height: 180, width: 300),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Bienvenue dans notre Application de Suivi des Stages !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Notre application est conçue pour faciliter le suivi des stages, le suivi des missions assignées, des objectifs fixés, et la génération de rapports.\n\n',
                      ),
                      TextSpan(
                        text:
                            'Elle offre une expérience utilisateur intuitive et efficace.\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Fonctionnalités de l\'application :\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.school, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('- Suivi des stages'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.task, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('- Suivi des missions'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.assignment, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('- Génération de rapports'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.done, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('- Gestion des objectifs'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
