import 'dart:async';
import 'package:flutter/material.dart';
import '../models/track_model.dart';

// Provedor para controle de reprodução simulada e estado do vinil/equalizador
class AudioPlayerProvider with ChangeNotifier {
  TrackModel? _currentTrack;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Timer? _ticker;

  TrackModel? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;

  // Inicia ou altera a faixa musical em reprodução
  void playTrack(TrackModel track) {
    _currentTrack = track;
    _isPlaying = true;
    _position = Duration.zero;
    _startTimer();
    notifyListeners();
  }

  // Alterna entre reprodução e pausa
  void togglePlayPause() {
    if (_currentTrack == null) return;
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      _startTimer();
    } else {
      _ticker?.cancel();
    }
    notifyListeners();
  }

  // Avança a posição da faixa manualmente
  void seek(Duration newPosition) {
    _position = newPosition;
    notifyListeners();
  }

  // Timer para simular o progresso do scrubber de áudio
  void _startTimer() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlaying || _currentTrack == null) return;
      if (_position.inMilliseconds >= _currentTrack!.durationMs) {
        _position = Duration.zero;
        _isPlaying = false;
        timer.cancel();
      } else {
        _position += const Duration(seconds: 1);
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

