// import 'dart:io';

import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:flutter/foundation.dart';

enum TtsState { playing, stopped, paused, continued }

class STTService {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "";
  double _confidence = 1.0;

  bool available = false;

  STTService() {
    _speech.initialize(
      onStatus: (status) {
        print("Speech recognition status is $status");
      },
      onError: (errorNotification) {
        print("There is an error while listening speech $errorNotification");
      },
    ).then((result) {
      available = result;
    });
  }

  void listen() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      _isListening = true;
      _speech.listen(
        onResult: (val) {
          _text = val.recognizedWords;
          if (val.hasConfidenceRating && val.confidence > 0) {
            _confidence = val.confidence;
          }
        },
      );
    }
  }

  // Future<dynamic> listenSpeech() async {
  //   print("Inside the listen speech service");
  //   if (available) {
  //     Future<dynamic> res = await _speech.listen(
  //       onResult: (result) {
  //         // print("Speech recognition result is: $result");
  //         print("This is result outcome!!!!!!!!!!!!!!!");
  //       },
  //     );
  //     return res;
  //   } else {
  //     print("The user has denied the use of speech recognition.");
  //     return Future.value({});
  //   }
  // }

  void stopListening() {
    // some time later...
    _isListening = false;
    _speech.stop();
  }
}
