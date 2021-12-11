import 'package:soon/core/use_case.dart';

import 'ma_terrasse_a_marseille_filter.dart';
import 'ma_terrasse_a_marseille_parser.dart';

class MaTerrasseAMarseilleUseCase extends UseCase {
  MaTerrasseAMarseilleUseCase() : super(MaTerrasseAMarseilleParser(), MaTerrasseAMarseilleFilter());

  @override
  List<String> urls() => ["https://materrasseamarseille.com"];
}
