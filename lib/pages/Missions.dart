// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:suivi_stage2/sqldb.dart';

class Missions extends StatefulWidget {
  final int stageId; // Stage ID
  final bool isProfesseur; // Flag to determine if user is Professeur

  Missions({required this.stageId, required this.isProfesseur});

  @override
  _MissionsState createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  late Future<List<Map<String, dynamic>>> _missionsFuture;
  late TextEditingController _missionController;

  @override
  void initState() {
    super.initState();
    _missionsFuture = _getMissionsData(widget.stageId);
    _missionController = TextEditingController();
  }

  Future<List<Map<String, dynamic>>> _getMissionsData(int stageId) async {
    List<Map<String, dynamic>> missions = await SqlDb().getMissionData(stageId);
    return missions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missions for Stage ${widget.stageId}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Stage ID is ${widget.stageId}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: widget.isProfesseur,
              child: ElevatedButton(
                onPressed: () {
                  _showMissionForm(context);
                },
                child: Text('Add Mission'),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _missionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                List<Map<String, dynamic>>? missions = snapshot.data;
                if (missions == null || missions.isEmpty) {
                  return Text('No Missions found.');
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: missions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(missions[index]['Text_Mission']),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMissionForm(BuildContext context) {
    String missionText = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Mission'),
          content: TextField(
            onChanged: (value) {
              missionText = value;
            },
            controller: _missionController,
            decoration: InputDecoration(labelText: 'Text Mission'),
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
                // Save the Mission text to the database
                await SqlDb().insertMission(widget.stageId, missionText , "En cours", "2022-01-01", "2022-01-01");

                // Close the dialog
                Navigator.of(context).pop();

                // Update the list of Missions
                setState(() {
                  _missionsFuture = _getMissionsData(widget.stageId);
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
