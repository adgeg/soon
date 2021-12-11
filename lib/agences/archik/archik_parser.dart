import 'package:html/dom.dart';
import 'package:soon/core/annonces_parser.dart';

class ArchikParser extends AnnoncesParser {
  @override
  List<Element> vignettes(Document d) => d.getElementsByClassName("singlebien");

  @override
  String titre(Element e) => e.getElementsByClassName("arrondissementbien").first.text;

  @override
  String imageUrl(Element e) => e
      .getElementsByClassName("imgquart")
      .first
      .attributes["style"]!
      .replaceAll("background-image:url(", "")
      .replaceAll(");", "");

  @override
  String url(Element e) => e.getElementsByClassName("imgquart").first.children.first.attributes["href"]!;

  @override
  String agence() => "Archik";

  @override
  String? prix(Element e) => e.getElementsByClassName("pricebien").first.text.trim();

  @override
  String? statut(Element e) => null;
}
