import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:soon/core/annonce.dart';
import 'package:soon/core/annonces_parser.dart';

class TerrasseEnVilleParser implements AnnoncesParser {
  @override
  List<Annonce> parseHtml(String html) {
    final Document document = parse(html);
    final List<Element> vignettes = document.getElementsByClassName("summary-thumbnail-outer-container");
    final List<Element> vraiesAnnonces = vignettes.where((e) => _estUneAnnonce(e)).toList();
    return vraiesAnnonces
        .map((e) => Annonce(
              titre: e.children[0].attributes["data-title"]!.trim(),
              imageUrl: e.getElementsByClassName("summary-thumbnail")[0].children[0].attributes["data-src"]!,
              url: "https://www.terrasse-en-ville.com" + e.children[0].attributes["href"]!,
              agence: "Terrasse en ville",
            ))
        .toList();
  }

  bool _estUneAnnonce(Element e) {
    final href = e.children[0].attributes["href"]!;
    return href.startsWith("/annonces") || href.startsWith("/location");
  }
}
