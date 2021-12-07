import 'package:soon/core/annonce.dart';

abstract class AnnoncesFilter {
  List<String> keywordsToRemove();

  List<Annonce> neGardeQueLesAnnoncesValides(List<Annonce> annonces) {
    return annonces.where((annonce) => _estUneAnnonceValide(annonce)).toList();
  }

  bool _estUneAnnonceValide(Annonce annonce) {
    for (var keyword in keywordsToRemove()) {
      if (titrePretPourLeFiltre(annonce).contains(keyword.toLowerCase())) return false;
    }
    return true;
  }

  String titrePretPourLeFiltre(Annonce annonce) => annonce.titre.toLowerCase().replaceAll("-", " ");
}
