import 'package:soon/core/use_case.dart';
import 'package:soon/ma_terrasse_a_marseille/ma_terrasse_a_marseille_use_case.dart';
import 'package:soon/terrasse_en_ville/terrasse_en_ville_use_case.dart';

import 'annonce.dart';

class AnnoncesProvider {
  final List<UseCase> usesCases = [
    MaTerrasseAMarseilleUseCase(),
    TerrasseEnVilleUseCase(),
  ];

  Future<List<Annonce>> annonces() async {
    final List<Annonce> annonces = [];
    for (var useCase in usesCases) {
      annonces.addAll(await useCase.annonces());
    }
    return annonces;
  }
}
