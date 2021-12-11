import 'package:soon/core/annonce.dart';
import 'package:soon/core/annonces_filter.dart';

class MaTerrasseAMarseilleFilter extends AnnoncesFilter {
  @override
  List<Annonce> neGardeQueLesAnnoncesValides(List<Annonce> annonces) {
    return super.neGardeQueLesAnnoncesValides(annonces.where((e) => e.prix! < 500000).toList());
  }
}
