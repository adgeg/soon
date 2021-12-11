import 'package:html/dom.dart';
import 'package:soon/core/annonces_parser.dart';

class MaTerrasseAMarseilleParser extends AnnoncesParser {
  @override
  List<Element> vignettes(Document d) => d.getElementsByClassName("wrapper_properties_ele");

  @override
  String titre(Element e) =>
      e.getElementsByClassName("rh_prop_card__details_elementor").first.children.first.text.trim();

  @override
  String imageUrl(Element e) => e
      .getElementsByClassName("rhea_figure_property_one")
      .first
      .getElementsByClassName("attachment-property-thumb-image")
      .first
      .attributes["src"]!;

  @override
  String url(Element e) =>
      e.getElementsByClassName("rhea_figure_property_one").first.children.first.attributes["href"]!;

  @override
  String agence() => "Ma terrasse à Marseille";

  @override
  String? prix(Element e) => e.getElementsByClassName("rh_prop_card__price").first.text.trim();

  @override
  String? statut(Element e) => e.getElementsByClassName("rh_prop_card__status").first.text.trim();
}
