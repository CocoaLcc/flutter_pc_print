// // ignore_for_file: unused_element, duplicate_ignore

// // import 'package:flutter_tts/flutter_tts.dart';

// // ignore: duplicate_ignore, duplicate_ignore
// class TTSUtil {
//   static TTSUtil? _tool;
//   static late FlutterTts _flutterTTS;
//   TTSUtil._internal() {
//     _flutterTTS = FlutterTts();
//   }

//   static TTSUtil sharedInstance() => _tool ??= TTSUtil._internal();

//   Future speak(String text) async {
//     /// 设置语言
//     await _flutterTTS.setLanguage("zh-CN");

//     /// 设置音量
//     await _flutterTTS.setVolume(0.3);

//     /// 设置语速
//     await _flutterTTS.setSpeechRate(1.12);

//     /// 音调
//     await _flutterTTS.setPitch(1.17);

//     // text = "你好，我的名字是李磊，你是不是韩梅梅？";
//     if (text.isNotEmpty) {
//       await _flutterTTS.speak(text);
//     }
//   }

//   // ignore:, unused_element
//   /// 暂停
//   Future _pause() async {
//     await _flutterTTS.pause();
//   }

//   /// 结束
//   Future _stop() async {
//     await _flutterTTS.stop();
//   }
// }
