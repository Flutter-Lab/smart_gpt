import 'package:translator_plus/translator_plus.dart';

class Translate {
  static Future<String> translate(
      {required String text, required String languageCode}) async {
    final translator = GoogleTranslator();

    // final input = "Здравствуйте. Ты в порядке?";

    // translator.translate(input, from: 'ru', to: 'en').then(print);
    // // prints Hello. Are you okay?

    var translation = await translator.translate(text, to: languageCode);
    print(translation);
    // prints Dart jest bardzo fajny!

    return translation.text;

    // print(await "example".translate(to: 'pt'));
    // prints exemplo
  }
}
