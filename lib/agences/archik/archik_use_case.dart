import 'package:soon/agences/archik/archik_parser.dart';
import 'package:soon/core/annonces_filter.dart';
import 'package:soon/core/use_case.dart';

class ArchikUseCase extends UseCase {
  ArchikUseCase() : super(ArchikParser(), AnnoncesFilter());

  @override
  List<String> urls() => [
        "https://archik.fr/immobilier/acheter/?_sft_ville=marseille&_sft_prix_des_biens=moins-de-300-000-e,entre-300-et-500-000-e"
      ];
}
