import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:soon/core/annonce.dart';

abstract class AnnoncesParser {
  List<Annonce> parseHtml(String html) {
    final Document document = parse(html);
    return vignettes(document).map((e) {
      return Annonce(
        titre: prix(e) != null ? "${titre(e)} - ${prix(e)}" : titre(e),
        imageUrl: imageUrl(e),
        url: url(e),
        agence: agence(),
        prix: prix(e)?._toInt(),
        statut: statut(e),
      );
    }).toList();
  }

  List<Element> vignettes(Document d);

  String titre(Element e);

  String imageUrl(Element e);

  String url(Element e);

  String agence();

  String? prix(Element e);

  String? statut(Element e);
}

extension on String {
  int _toInt() => int.parse(replaceAll("€", "").replaceAll(" ", "").replaceAll(" ", ""));
}
