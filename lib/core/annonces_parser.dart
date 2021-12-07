import 'package:html/dom.dart';
import 'package:soon/core/annonce.dart';

abstract class AnnoncesParser {
  List<Annonce> parse(Document document);
}
