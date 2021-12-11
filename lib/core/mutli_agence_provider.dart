import 'package:async/async.dart' show StreamGroup;
import 'package:soon/agences/archik/archik_use_case.dart';
import 'package:soon/agences/ma_terrasse_a_marseille/ma_terrasse_a_marseille_use_case.dart';
import 'package:soon/agences/terrasse_en_ville/terrasse_en_ville_use_case.dart';
import 'package:soon/core/use_case.dart';

import 'annonce.dart';

class MultiAgencesProvider {
  final List<UseCase> useCases = [
    ArchikUseCase(),
    MaTerrasseAMarseilleUseCase(),
    TerrasseEnVilleUseCase(),
  ];

  Stream<List<Annonce>> annonces() {
    return StreamGroup.merge(useCases.map((e) => e.annonces()));
  }
}
