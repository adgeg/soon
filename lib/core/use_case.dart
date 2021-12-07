import 'package:soon/core/annonce.dart';
import 'package:soon/core/annonces_filter.dart';
import 'package:soon/core/annonces_parser.dart';
import 'package:soon/network/html_repository.dart';

abstract class UseCase {
  final AnnoncesParser parser;
  final AnnoncesFilter filter;
  final HtmlRepository repository = HtmlRepository();

  List<String> urls();

  UseCase(this.parser, this.filter);

  Future<List<Annonce>> annonces() async {
    final List<Annonce> annonces = [];
    for (var url in urls()) {
      final html = await repository.getHtml(url);
      if (html == null) continue;
      final toutesLesAnnonces = parser.parseHtml(html);
      annonces.addAll(filter.neGardeQueLesAnnoncesValides(toutesLesAnnonces));
    }
    return annonces;
  }
}
