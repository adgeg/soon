import 'package:html/dom.dart';
import 'package:soon/core/annonce.dart';

abstract class AnnoncesParser {
  List<Annonce> parseHtml(String html);

  String? prix(Element e);
}
