import 'package:soon/core/annonce.dart';

abstract class AnnoncesParser {
  List<Annonce> parseHtml(String html);
}
