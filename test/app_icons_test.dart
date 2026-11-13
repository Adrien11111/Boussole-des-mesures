import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

/// Couleur « encre » du logo (#14202E), identique au fond de l'icône.
const ink = 0xFF14202E;

Future<(int w, int h, int Function(int x, int y) at)> decode(String path) async {
  final codec = await ui.instantiateImageCodec(File(path).readAsBytesSync());
  final img = (await codec.getNextFrame()).image;
  final data = (await img.toByteData())!;
  int at(int x, int y) {
    final i = (y * img.width + x) * 4;
    return (data.getUint8(i + 3) << 24) | (data.getUint8(i) << 16) | (data.getUint8(i + 1) << 8) | data.getUint8(i + 2);
  }
  return (img.width, img.height, at);
}

void main() {
  const fullBleed = {
    'master': 'assets/icon/icon.png',
    'iOS 1024': 'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png',
    'macOS 1024': 'macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png',
    'web 512': 'web/icons/Icon-512.png',
    'web 192': 'web/icons/Icon-192.png',
  };

  for (final e in fullBleed.entries) {
    testWidgets('${e.key} icon carries the Boussole logo (ink background)', (t) async {
      await t.runAsync(() async {
        final (w, h, at) = await decode(e.value);
        expect(at(w ~/ 2 ~/ 8, h ~/ 2 ~/ 8), ink, reason: e.value);
        expect(at(w - 1 - w ~/ 16, h - 1 - h ~/ 16), ink, reason: e.value);
        // le centre porte le dessin : il ne doit plus être de la couleur du fond
        expect(at(w ~/ 2, h ~/ 2) == ink, isFalse, reason: e.value);
      });
    });
  }

  test('master icon is 1024x1024 and opaque on iOS', () async {
    final bytes = File('assets/icon/icon.png').readAsBytesSync();
    final width = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
    final height = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
    expect([width, height], [1024, 1024]);
    final ios = File('ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png').readAsBytesSync();
    expect(ios[25], isNot(6), reason: 'iOS refuse les icônes avec canal alpha (type couleur 6)');
  });

  test('Android has an adaptive icon with the brand background colour', () {
    final xml = File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml');
    expect(xml.existsSync(), isTrue);
    final colors = File('android/app/src/main/res/values/colors.xml');
    expect(colors.readAsStringSync().toLowerCase(), contains('#14202e'));
  });

  test('Windows icon exists and is not the Flutter default size', () {
    expect(File('windows/runner/resources/app_icon.ico').existsSync(), isTrue);
  });
}
