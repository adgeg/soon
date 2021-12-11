import 'package:async/async.dart' show StreamGroup;
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

  Stream<List<Annonce>> annonces() =>
      StreamGroup.mergeBroadcast(urls().map((url) => Stream.fromFuture(_annoncesForUrl(url))));

  Future<List<Annonce>> _annoncesForUrl(String url) async {
    final html = await repository.getHtml(url);
    if (html == null) return [];
    final toutesLesAnnonces = parser.parseHtml(html);
    return filter.neGardeQueLesAnnoncesValides(toutesLesAnnonces);
  }
}
