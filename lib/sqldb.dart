// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    // ignore: await_only_futures
    String path = await join(databasepath, 'Mydb.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 25, onUpgrade: _onUpgrade);
    return mydb;
  }

  // if we wanna update something after the initalizing of our database, it cannot be possible until we delete it or making some wrong decision
  // then the best solution will be the onUpgrade function that will update our database with a new version

  _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("OnUpgrade------------");
  }

//   _onCreate(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE Utilisateurs (
//       id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
//       nom_utilisateur TEXT NOT NULL,
//       prenom_utilisateur TEXT NOT NULL,
//       email TEXT NOT NULL,
//       Role TEXT NOT NULL,
//       password TEXT
//     )
//   ''');

//     // Creating Stages table
//     await db.execute('''
//     CREATE TABLE Stages (
//       id INTEGER PRIMARY KEY,
//       Sujet_Stage TEXT,
//       Lieu_Stage TEXT,
//       Type_Stage TEXT,
//       id_Professeur INTEGER REFERENCES Utilisateurs(id),
//       email_Etudiant TEXT REFERENCES Utilisateurs(email)
//     )
//   ''');

//     await db.execute('''
//     CREATE TABLE Objectifs_Data (
//       id INTEGER PRIMARY KEY,
//       Text_Objectif TEXT,
//       id_Stage INTEGER REFERENCES Stages(id)
//     )
//   ''');
// // Mission_Data_Data
//     await db.execute('''
//     CREATE TABLE Mission_Data (
//       id INTEGER PRIMARY KEY,
//       Titre_Mission TEXT,
//       Etat_Mission TEXT,
//       Date_Debut_Mission TEXT,
//       Date_Fin_Mission TEXT,
//       id_Stage INTEGER REFERENCES Stages(id)
//     )
//   ''');

//     print("DATABASE AND TABLES HAVE BEEN CREATED!");
//   }

_onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE Utilisateurs (
      id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
      nom_utilisateur TEXT NOT NULL,
      prenom_utilisateur TEXT NOT NULL,
      email TEXT NOT NULL,
      Role TEXT NOT NULL,
      password TEXT
    )
  ''');

  // Creating Stages table
  await db.execute('''
    CREATE TABLE Stages (
      id INTEGER PRIMARY KEY,
      Sujet_Stage TEXT,
      Lieu_Stage TEXT,
      Type_Stage TEXT,
      id_Professeur INTEGER REFERENCES Utilisateurs(id),
      email_Etudiant TEXT REFERENCES Utilisateurs(email)
    )
  ''');

  await db.execute('''
    CREATE TABLE Objectifs_Data (
      id INTEGER PRIMARY KEY,
      Text_Objectif TEXT,
      id_Stage INTEGER REFERENCES Stages(id)
    )
  ''');

  // Mission_Data_Data
  await db.execute('''
    CREATE TABLE Mission_Data (
      id INTEGER PRIMARY KEY,
      Titre_Mission TEXT,
      Etat_Mission TEXT,
      Date_Debut_Mission TEXT,
      Date_Fin_Mission TEXT,
      id_Stage INTEGER REFERENCES Stages(id)
    )
  ''');

  print("DATABASE AND TABLES HAVE BEEN CREATED!");
}


  Future<List<String>> getStudentEmails() async {
    Database? mydb = await db;

    // Query for the emails of students who don't have any stages
    List<Map<String, dynamic>> students = await mydb!.rawQuery('''
    SELECT email
    FROM Utilisateurs
    WHERE Role = "Etudiant" AND email NOT IN (
      SELECT email_Etudiant FROM Stages
    )
  ''');

    // Extract emails from the query result
    List<String> emails = [];
    for (var student in students) {
      emails.add(student['email']);
    }

    return emails;
  }

  Future<void> insertStage(int idProfesseur, String sujet, String lieu,
      String type, String email) async {
    Database? db = await this.db;
    if (db != null) {
      await db.insert('Stages', {
        'Sujet_Stage': sujet,
        'Lieu_Stage': lieu,
        'Type_Stage': type,
        'id_Professeur': idProfesseur,
        'email_Etudiant': email,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getUserStages(
      int userId, String userRole) async {
    Database? db = await this.db;
    if (db != null) {
      if (userRole == 'Professeur') {
        return await db
            .query('Stages', where: 'id_Professeur = ?', whereArgs: [userId]);
      } else if (userRole == 'Etudiant') {
        Map<String, dynamic> user = await db
            .query('Utilisateurs', where: 'id = ?', whereArgs: [userId]).then(
                (List<Map<String, dynamic>> users) => users.first);
        String userEmail = user['email'];
        return await db.query('Stages',
            where: 'email_Etudiant = ?', whereArgs: [userEmail]);
      } else {
        // Handle other roles here
        return [];
      }
    } else {
      return [];
    }
  }

  Future<void> deleteStage(int stageId) async {
    Database? db = await this.db;
    await db!.delete('Stages', where: 'id = ?', whereArgs: [stageId]);
  }

// Objectifs_Data

// ********************************************************************************************
// -------------------------  les fonctions pour la table Objectifs_Data -------------------------
// ******************************************************************************************** 

  Future<void> insertObjectif(int stageId, String textObjectif) async {
    Database? db = await this.db;
    if (db != null) {
      await db.insert('Objectifs_Data', {
        'Text_Objectif': textObjectif,
        'id_Stage': stageId,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getObjectifs(int stageId) async {
    Database? db = await this.db;
    if (db != null) {
      return await db
          .query('Objectifs_Data', where: 'id_Stage = ?', whereArgs: [stageId]);
    } else {
      return [];
    }
  }

  Future<void> deleteObjectif(int objectId) async {
    Database? db = await this.db;
    if (db != null) {
      await db.delete('Objectifs_Data', where: 'id = ?', whereArgs: [objectId]);
    }
  }

// les fonctions crud pour les user ;
  readData(String sql) async {
    Database? mydb = await db;
    // error possible : The method 'rawQuery' can't be unconditionally invoked because the receiver can be 'null'.
    // solution : mydb! : we assure you bro that's not gonna be null even if it can be  (Database? mydb)
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    Database? mydb = await db;

    // Exécuter une requête pour récupérer l'utilisateur avec l'e-mail donné
    List<Map<String, dynamic>> users = await mydb!.rawQuery(
        'SELECT * FROM Utilisateurs WHERE email = ? LIMIT 1', [email]);

    // Vérifier s'il y a un utilisateur avec cet e-mail
    if (users.isNotEmpty) {
      // Récupérer le premier utilisateur trouvé (il ne devrait y en avoir qu'un en raison de LIMIT 1)
      Map<String, dynamic> user = users.first;

      // Vérifier si le mot de passe correspond
      if (user['password'] == password) {
        // Le mot de passe est correct, retourner les informations de l'utilisateur
        return user;
      }
    }

    // Aucun utilisateur trouvé avec cet e-mail ou mot de passe incorrect
    return null;
  }

//  *****************************************************************************************
// ---------------------- les fonction pour la table misssion ----------------------------
// *****************************************************************************************

  Future<void> insertMission(int stageId, String titre, String etat,
      String dateDebut, String dateFin) async {
    await _db!.insert('Mission_Data', {
      'id_Stage': stageId,
      'Titre_Mission': titre,
      'Etat_Mission': etat,
      'Date_Debut_Mission': dateDebut,
      'Date_Fin_Mission': dateFin,
    });
      }
// Mission_Data_Data
    Future<List<Map<String, dynamic>>> getMissionData(int stageId) async {
      List<Map<String, dynamic>> missionData = await _db!.query('MissionData',
          // wheMission_Data_Datare: 'id_Stage = ?',
          whereArgs: [stageId]);
      return missionData;
    }

// Mission_Data_Data
    Future<void> deleteMission(int missionId) async {
      await _db
          ?.delete('Mission_Data', where: 'id = ?', whereArgs: [missionId]);
    }
  }

