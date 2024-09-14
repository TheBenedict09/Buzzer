import 'package:buzzer2/buzzer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isBuzzerActive = false;
  int startTime = 0;
  final String userId = "Team1"; // Using Team1
  String lastUID =
      "null"; // Properly naming the variable instead of ColorChanging

  @override
  void initState() {
    super.initState();
    _listenToBuzzerData();
  }

  Future<void> _listenToBuzzerData() async {
    _firestore.collection('buzzer_data').doc('data').snapshots().listen(
      (snapshot) {
        final data = snapshot.data();
        if (data != null) {
          setState(() {
            _isBuzzerActive = data['onPressed'] ?? false;
            startTime = data['startTime'] ?? 0;
            lastUID = data['lastUID'] ?? "null"; // Updating lastUID properly
          });
        }
      },
    );
  }

  Future<void> updateBuzzerStatus(int endTime) async {
    await _firestore.collection('buzzer_data').doc('data').update({
      'onPressed': true,
      'lastUID': "Team1", // This will now store 'Team1'
      'endTeam1': endTime, // Storing endTime for Team1
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                const Color.fromRGBO(31, 31, 31, 1),
                _isBuzzerActive && lastUID == userId
                    ? Colors
                        .red // Set the background to red if this team pressed
                    : _isBuzzerActive
                        ? Colors
                            .grey // Set the background to grey if other team pressed
                        : Colors.lightGreen, // Set to green initially
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                Image.asset(
                  'assets/images/mindcraft.png',
                  width: MediaQuery.sizeOf(context).width * 0.7,
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
                Text(
                  "Team 1", // Displaying the team name
                  style: TextStyle(
                      color: const Color.fromARGB(255, 137, 134, 134),
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.sizeOf(context).width * 0.13),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
                // Pass the necessary data to the Buzzer widget
                Buzzer(
                  isBuzzerActive: _isBuzzerActive,
                  startTime: startTime,
                  userId: userId,
                  updateBuzzerStatus: updateBuzzerStatus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
