import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:soon/core/annonce.dart';
import 'package:soon/core/annonces_parser.dart';

class ArchikParser implements AnnoncesParser {
  @override
  List<Annonce> parseHtml(String html) {
    final Document document = parse(html);
    final List<Element> vignettes = document.getElementsByClassName("singlebien");
    return vignettes.map((e) {
      final titre = e.getElementsByClassName("arrondissementbien").first.text;
      final prixEnTexte = e.getElementsByClassName("pricebien").first.text.trim();
      return Annonce(
        titre: "$titre - $prixEnTexte",
        imageUrl: _imageUrl(e),
        url: _url(e),
        agence: "Archik",
        prix: _toInt(prixEnTexte),
      );
    }).toList();
  }

  @override
  String? prix(Element e) => e.getElementsByClassName("pricebien").first.text.trim();


  String _imageUrl(Element e) => e
      .getElementsByClassName("imgquart")
      .first
      .attributes["style"]!
      .replaceAll("background-image:url(", "")
      .replaceAll(");", "");

  String _url(Element e) => e.getElementsByClassName("imgquart").first.children.first.attributes["href"]!;

  int _toInt(String prixEnTexte) => int.parse(prixEnTexte.replaceAll("€", "").replaceAll(" ", "").replaceAll(" ", ""));
}
