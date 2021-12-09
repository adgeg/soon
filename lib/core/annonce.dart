class Annonce {
  final String titre;
  final String imageUrl;
  final String url;
  final String agence;
  final int? prix;
  final String? statut;

  Annonce({
    required this.titre,
    required this.imageUrl,
    required this.url,
    required this.agence,
    this.prix,
    this.statut,
  });
}
