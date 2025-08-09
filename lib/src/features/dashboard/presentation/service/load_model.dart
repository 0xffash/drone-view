import 'package:tflite_flutter/tflite_flutter.dart';

Future<void> loadModel() async {
  try {
    final interpreter = await Interpreter.fromAsset('assets/model.tfrecord');
    // Store interpreter for later use
  } catch (e) {
    print('Failed to load model: $e');
  }
}