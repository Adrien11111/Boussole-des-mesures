import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

/// Garde de configuration : la compilation GTK réelle est vérifiée dans Docker (voir README).
void main() {
  final cc = File('linux/runner/my_application.cc');
  final cmake = File('linux/CMakeLists.txt');

  test('the Linux icon resource exists and is a PNG', () {
    final f = File('linux/runner/resources/app_icon.png');
    expect(f.existsSync(), isTrue);
    expect(f.readAsBytesSync().sublist(1, 4), [0x50, 0x4E, 0x47]);
  });

  test('CMake installs the icon into the bundle data directory', () {
    expect(cmake.readAsStringSync(), contains('runner/resources/app_icon.png'));
    expect(cmake.readAsStringSync(), contains('icons'));
  });

  test('the GTK window sets its icon from the bundled file', () {
    final src = cc.readAsStringSync();
    expect(src, contains('gtk_window_set_icon_from_file'));
    expect(src, contains('/proc/self/exe'));
    expect(src, contains('data/icons/boussole.png'));
  });

  test('the window title is the product name, not the package name', () {
    final src = cc.readAsStringSync();
    expect(src, contains('"Boussole des mesures"'));
    expect(src, isNot(contains('"boussole"')));
  });

  test('a desktop entry maps the app id to its icon for Wayland launchers', () {
    final d = File('linux/packaging/fr.boussole.boussole.desktop').readAsStringSync();
    expect(d, contains('Name=Boussole des mesures'));
    expect(d, contains('Icon=fr.boussole.boussole'));
    expect(d, contains('Exec=boussole'));
    expect(d, contains('StartupWMClass=fr.boussole.boussole'));
  });
}
