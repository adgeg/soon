import 'package:soon/core/annonce.dart';

class AnnoncesFilter {
  List<String> keywordsToRemove() => ["VENDU", "SOUS OFFRE", "SOUS PROMESSE", "COMPROMIS"];

  List<Annonce> neGardeQueLesAnnoncesValides(List<Annonce> annonces) {
    return annonces.where((annonce) => _estUneAnnonceValide(annonce)).toList();
  }

  bool _estUneAnnonceValide(Annonce annonce) {
    for (var keyword in keywordsToRemove()) {
      if (_textePretPourLeFiltre(annonce.titre)?.contains(keyword.toLowerCase()) == true) return false;
      if (_textePretPourLeFiltre(annonce.statut)?.contains(keyword.toLowerCase()) == true) return false;
    }
    return true;
  }

  String? _textePretPourLeFiltre(String? texte) => texte?.toLowerCase().replaceAll("-", " ");
}
