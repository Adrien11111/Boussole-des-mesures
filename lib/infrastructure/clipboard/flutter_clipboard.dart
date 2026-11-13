import 'package:flutter/services.dart';

import '../../application/ports/clipboard_port.dart';

class FlutterClipboard implements ClipboardPort {
  @override
  Future<bool> copy(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } catch (_) {
      return false;
    }
  }
}
