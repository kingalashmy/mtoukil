


// ************************************************************************************   /


// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:suivi_stage2/sqldb.dart';
import 'package:suivi_stage2/pages/Objectifs.dart'; 


class ListStage extends StatefulWidget {
  final Map<String, dynamic> userData;

  // ignore: use_super_parameters
  const ListStage({Key? key, required this.userData}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListStageState createState() => _ListStageState();
}

class _ListStageState extends State<ListStage> {
  late Future<List<Map<String, dynamic>>> _stagesFuture;

  @override
  void initState() {
    super.initState();
    _stagesFuture = _getProfessorStages(widget.userData['id']);
  }

  Future<List<Map<String, dynamic>>> _getProfessorStages(int professorId) async {
    String userRole = widget.userData['Role'];
    List<Map<String, dynamic>> stages = await SqlDb().getUserStages(professorId, userRole);
    return stages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Stages'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _stagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<Map<String, dynamic>>? stages = snapshot.data;
          if (stages == null || stages.isEmpty) {
            return Center(child: Text('No stages found.'));
          }
          return ListView.builder(
            itemCount: stages.length,
            itemBuilder: (context, index) {
              return _buildStageItem(stages[index]);
            },
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: widget.userData['Role'] == "Professeur",
        child: FloatingActionButton(
          onPressed: () {
            _showAddStageDialog(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildStageItem(Map<String, dynamic> stage) {
    bool isProfessor = widget.userData['Role'] == 'Professeur';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(stage['Sujet_Stage']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lieu: ${stage['Lieu_Stage']}'),
            Text('Type: ${stage['Type_Stage']}'), // Adding type of stage
          ],
        ),
        trailing: isProfessor
            ? IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteStage(stage['id']); // Call the delete function with the stage id
                },
              )
            : null, // Show delete button only for professors
        onTap: () {
          // Navigate to the Objectifs page when tapped
          Navigator.push(
            context,
            MaterialPageRoute(
  builder: (context) => Objectifs(
    stageId: stage['id'],
    isProfesseur: widget.userData['Role'] == 'Professeur', // Determine if user is Professeur
  ),
),

          );
        },
      ),
    );
  }

  void _showAddStageDialog(BuildContext context) async {
    List<String> studentEmails = await SqlDb().getStudentEmails();
    String selectedStudentEmail = studentEmails.isNotEmpty ? studentEmails[0] : '';
    String sujetStage = '';
    String lieuStage = '';
    String typeStage = 'Stage interne'; // Default value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Stage'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Sujet de Stage'),
                  onChanged: (value) {
                    sujetStage = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(labelText: 'Lieu de Stage'),
                  onChanged: (value) {
                    lieuStage = value;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Type de Stage'),
                  value: 'Stage interne', // Default value
                  onChanged: (String? value) {
                    typeStage = value!;
                  },
                  items: <String>[
                    'Stage interne',
                    'Stage Externe',
                    'Stage a distance'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedStudentEmail,
                  onChanged: (String? value) {
                    selectedStudentEmail = value!;
                  },
                  items: studentEmails.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveStageData(sujetStage, lieuStage, typeStage, selectedStudentEmail);
                Navigator.of(context).pop();
                setState(() {
                  _stagesFuture = _getProfessorStages(widget.userData['id']);
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveStageData(String sujet, String lieu, String type, String email) async {
    await SqlDb().insertStage(widget.userData['id'], sujet, lieu, type, email);
  }

  Future<void> _deleteStage(int stageId) async {
    await SqlDb().deleteStage(stageId);
    setState(() {
      _stagesFuture = _getProfessorStages(widget.userData['id']);
    });
  }
}
