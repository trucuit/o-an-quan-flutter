import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Lightweight game SFX. Fire-and-forget, globally mutable mute, and tolerant
/// of missing assets / unsupported platforms (errors are swallowed so gameplay
/// never breaks on audio).
class SoundPlayer {
  SoundPlayer._();
  static final SoundPlayer instance = SoundPlayer._();

  final AudioPlayer _player = AudioPlayer(playerId: 'oaq_sfx')
    ..setReleaseMode(ReleaseMode.stop);

  /// User-facing mute toggle (persisted by the caller if desired).
  bool muted = false;

  Future<void> _play(String asset) async {
    if (muted) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$asset'), volume: 0.7);
    } catch (e) {
      // Missing asset, codec, or unsupported platform — ignore.
      if (kDebugMode) debugPrint('SoundPlayer: $asset failed: $e');
    }
  }

  void sow() => _play('sow.wav');
  void capture() => _play('capture.wav');
  void invalid() => _play('invalid.wav');

  void dispose() => _player.dispose();
}
