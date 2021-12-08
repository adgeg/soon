import 'package:soon/core/annonces_filter.dart';

class TerrasseEnVilleFilter extends AnnoncesFilter {
  @override
  List<String> keywordsToRemove() => ["VENDU", "SOUS OFFRE", "SOUS PROMESSE", "COMPROMIS"];
}
