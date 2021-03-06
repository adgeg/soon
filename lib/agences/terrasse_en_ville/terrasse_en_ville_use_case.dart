import 'package:soon/agences/terrasse_en_ville/terrasse_en_ville_parser.dart';
import 'package:soon/core/annonces_filter.dart';
import 'package:soon/core/use_case.dart';

class TerrasseEnVilleUseCase extends UseCase {
  TerrasseEnVilleUseCase() : super(TerrasseEnVilleParser(), AnnoncesFilter());

  @override
  List<String> urls() => [
        "https://www.terrasse-en-ville.com/-300-000-marseille",
        "https://www.terrasse-en-ville.com/500000-marseille",
        "https://www.terrasse-en-ville.com/-1000-marseille-annonces-locations",
        "https://www.terrasse-en-ville.com/-1500-marseille-annonces-locations",
      ];
}
