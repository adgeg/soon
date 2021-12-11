import 'package:html/dom.dart';
import 'package:soon/core/annonces_parser.dart';

class TerrasseEnVilleParser extends AnnoncesParser {
  @override
  List<Element> vignettes(Document d) {
    final List<Element> vignettes = d.getElementsByClassName("summary-thumbnail-outer-container");
    final List<Element> vraiesAnnonces = vignettes.where((e) => _estUneAnnonce(e)).toList();
    return vraiesAnnonces;
  }

  @override
  String titre(Element e) => e.children[0].attributes["data-title"]!.trim();

  @override
  String imageUrl(Element e) => e.getElementsByClassName("summary-thumbnail")[0].children[0].attributes["data-src"]!;

  @override
  String url(Element e) => "https://www.terrasse-en-ville.com" + e.children[0].attributes["href"]!;

  @override
  String agence() => "Terrasse en ville";

  @override
  String? prix(Element e) => null;

  @override
  String? statut(Element e) => null;

  bool _estUneAnnonce(Element e) {
    final href = e.children[0].attributes["href"]!;
    return href.startsWith("/annonces") || href.startsWith("/location");
  }
}
