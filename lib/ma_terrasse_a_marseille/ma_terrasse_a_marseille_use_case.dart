import 'package:soon/core/use_case.dart';
import 'package:soon/ma_terrasse_a_marseille/ma_terrasse_a_marseille_filter.dart';
import 'package:soon/ma_terrasse_a_marseille/ma_terrasse_a_marseille_parser.dart';

class MaTerrasseAMarseilleUseCase extends UseCase {
  MaTerrasseAMarseilleUseCase() : super(MaTerrasseAMarseilleParser(), MaTerrasseAMarseilleFilter());

  List<String> urls() => ["https://materrasseamarseille.com"];
}
