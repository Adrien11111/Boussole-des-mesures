import '../../domain/entities/person.dart';
import '../../domain/entities/scale.dart';

class ShareCodeException implements Exception {
  const ShareCodeException(this.message);
  final String message;
  @override
  String toString() => message;
}

abstract class ShareCodecPort {
  String encode(String name, Answers answers, Comments comments);

  /// Lève [ShareCodeException] si le code est invalide.
  Person decode(String code);
}
