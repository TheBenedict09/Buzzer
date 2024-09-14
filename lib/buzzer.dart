import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class Buzzer extends StatefulWidget {
  final bool isBuzzerActive;
  final int startTime;
  final String userId;
  final Future<void> Function(
    int endTime,
  ) updateBuzzerStatus;

  const Buzzer({
    Key? key,
    required this.isBuzzerActive,
    required this.startTime,
    required this.userId,
    required this.updateBuzzerStatus,
  }) : super(key: key);

  @override
  State<Buzzer> createState() => _BuzzerState();
}

class _BuzzerState extends State<Buzzer> {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  int endTime = 0;
  bool _isLastPressed = false;

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playBuzzerSound() async {
    try {
      await _assetsAudioPlayer.open(
        Audio('assets/mp3/buzzer.mp3'),
        autoStart: true,
      );  
    } catch (e) {
      print("Error playing buzzer sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.5,
      height: MediaQuery.sizeOf(context).height * 0.5,
      child: FloatingActionButton(
        backgroundColor: !widget.isBuzzerActive && !_isLastPressed
            ? Color.fromARGB(255, 237, 63, 60)
            : Colors.grey, // Gray out the button when disabled
        elevation: 30,
        splashColor: Colors.red,
        shape: const CircleBorder(),
        onPressed: !widget.isBuzzerActive && !_isLastPressed
            ? () async {
                endTime = DateTime.now().millisecondsSinceEpoch;
                await widget.updateBuzzerStatus(
                  endTime,
                );
                await _playBuzzerSound(); // Play the buzzer sound
              }
            : null,
        child: Text(
          'Buzzer',
          style: TextStyle(
              fontSize: MediaQuery.sizeOf(context).width * 0.1,
              color: Colors.black),
        ),
      ),
    );
  }
}
