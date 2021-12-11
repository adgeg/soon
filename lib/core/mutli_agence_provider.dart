import 'package:async/async.dart' show StreamGroup;
import 'package:soon/core/use_case.dart';
import 'package:soon/ma_terrasse_a_marseille/ma_terrasse_a_marseille_use_case.dart';
import 'package:soon/terrasse_en_ville/terrasse_en_ville_use_case.dart';

import 'annonce.dart';

class MultiAgencesProvider {
  final List<UseCase> useCases = [
    MaTerrasseAMarseilleUseCase(),
    TerrasseEnVilleUseCase(),
  ];

  Stream<List<Annonce>> annonces() => StreamGroup.merge(useCases.map((e) => e.annonces()));
}
