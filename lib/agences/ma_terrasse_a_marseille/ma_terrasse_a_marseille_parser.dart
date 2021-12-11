import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:soon/core/annonce.dart';
import 'package:soon/core/annonces_parser.dart';

class MaTerrasseAMarseilleParser implements AnnoncesParser {
  @override
  List<Annonce> parseHtml(String html) {
    final Document document = parse(html);
    final List<Element> vignettes = document.getElementsByClassName("wrapper_properties_ele");
    return vignettes.map((e) {
      final titre = e.getElementsByClassName("rh_prop_card__details_elementor").first.children.first.text.trim();
      final prixEnTexte = e.getElementsByClassName("rh_prop_card__price").first.text.trim();
      return Annonce(
        titre: "$titre - $prixEnTexte",
        prix: _toInt(prixEnTexte),
        statut: e.getElementsByClassName("rh_prop_card__status").first.text.trim(),
        imageUrl: _imageUrl(e),
        url: e.getElementsByClassName("rhea_figure_property_one").first.children.first.attributes["href"]!,
        agence: "Ma terrasse à Marseille",
      );
    }).toList();
  }

  String _imageUrl(Element e) => e
      .getElementsByClassName("rhea_figure_property_one")
      .first
      .getElementsByClassName("attachment-property-thumb-image")
      .first
      .attributes["src"]!;

  int _toInt(String prixEnTexte) => int.parse(prixEnTexte.replaceAll("€", "").replaceAll(" ", "").replaceAll(" ", ""));

  @override
  String? prix(Element e) => e.getElementsByClassName("rh_prop_card__price").first.text.trim();
}
