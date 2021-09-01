import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TTSService {
  String _language = "en-US";
  // String? _engine;
  double _volume = 1.0;
  double _pitch = 1.0;
  double _rate = 1.0;
  // bool _isCurrentLanguageInstalled = false;

  String? _newVoiceText;
  // int? _inputLength;
  FlutterTts flutterTts = FlutterTts();

  TtsState _ttsState = TtsState.stopped;

  get isPlaying => _ttsState == TtsState.playing;
  get isStopped => _ttsState == TtsState.stopped;
  get isPaused => _ttsState == TtsState.paused;
  get isContinued => _ttsState == TtsState.continued;

  set setIsPlaying(bool isPlaying) {
    _ttsState = TtsState.playing;
  }

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  TTSService() {
    print("object");
    flutterTts.setSharedInstance(true);

    // initialise
    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      print("Playing");
      _ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      _ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
      _ttsState = TtsState.stopped;
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        print("Paused");
        _ttsState = TtsState.paused;
      });

      flutterTts.setContinueHandler(() {
        print("Continued");
        _ttsState = TtsState.continued;
      });
    }

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      _ttsState = TtsState.stopped;
    });
  }

  Future<dynamic> getLanguages() => flutterTts.getLanguages;

  Future<dynamic> getEngines() => flutterTts.getEngines;

  // Future speak() async {
  //   var result = await flutterTts.speak("Hello World");
  //   if (result == 1) _ttsState = TtsState.playing;
  // }

  Future speak(String text) async {
    _newVoiceText = text;
    await flutterTts.setVolume(_volume);
    await flutterTts.setSpeechRate(_rate);
    await flutterTts.setPitch(_pitch);
    await flutterTts.setLanguage(_language);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1) _ttsState = TtsState.stopped;
  }

  Future pause() async {
    var result = await flutterTts.pause();
    if (result == 1) _ttsState = TtsState.paused;
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }
}
