abstract class ClipboardPort {
  /// Renvoie false si la copie est impossible.
  Future<bool> copy(String text);
}
