import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Buzzer extends StatefulWidget {
  const Buzzer({Key? key}) : super(key: key);

  @override
  State<Buzzer> createState() => _BuzzerState();
}

class _BuzzerState extends State<Buzzer> {
  final _firestore = FirebaseFirestore.instance;
  bool _isBuzzerActive = false;

  @override
  void initState() {
    super.initState();
    _firestore
        .collection('buzzer_data')
        .doc('data')
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();
      setState(() {
        _isBuzzerActive = data?['onPressed'] ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.5,
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: !_isBuzzerActive
                ? () async {
                    await _firestore
                        .collection('buzzer_data')
                        .doc('data')
                        .update(
                      {'onPressed': true},
                    );
                  }
                : null,
            child: Text(
              'Buzzer',
              style:
                  TextStyle(fontSize: MediaQuery.sizeOf(context).width * 0.1),
            ),
          ),
        ),
        // SizedBox(
        // height: MediaQuery.sizeOf(context).height * 0.01,
        // ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.5,
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              await _firestore.collection('buzzer_data').doc('data').update(
                {'onPressed': false},
              );
            },
            child: Text(
              'Reset',
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).width * 0.1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
