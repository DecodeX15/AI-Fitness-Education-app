import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';

class OnnxService {
  late OrtSession _session;

  Future<void> init() async {
    OrtEnv.instance.init();
    final modelData = await rootBundle.load('assets/model.onnx');
    final modelBytes = modelData.buffer.asUint8List();
    final options = OrtSessionOptions();
    _session = await OrtSession.fromBuffer(modelBytes, options);
    print("ONNX model loaded successfully");
  }
}