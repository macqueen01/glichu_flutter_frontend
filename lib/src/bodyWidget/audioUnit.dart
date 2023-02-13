import 'package:just_audio/just_audio.dart';

AudioPlayer player = AudioPlayer();

Future audioPlayer() async {
  await player.setVolume(75);
  await player.setSpeed(1);
  await player.setAsset('sample_audios/0.wav');
  player.play();
}
