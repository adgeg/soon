import 'package:flutter_test/flutter_test.dart';
import 'package:soon/agences/terrasse_en_ville/terrasse_en_ville_parser.dart';
import 'package:soon/core/annonces_filter.dart';

import 'test_assets.dart';

void main() {
  group('achats', () {
    const path = "terrasse-en-ville-achats.html";
    test('parse', () {
      final annonces = TerrasseEnVilleParser().parseHtml(loadTestAssets(path));
      expect(annonces.length, 17);
      expect(annonces.first.titre, "MAZARGUES - APPARTEMENT T2 - 45 M2 - TERRASSE - PARKING - 249 000 €");
      expect(
        annonces.first.imageUrl,
        "https://images.squarespace-cdn.com/content/v1/5ac338c57106998b66912a94/1632481934077-0XLWFKHRX87IM1Y4J3QG/IMG_9513_4_5_6_7.jpg",
      );
      expect(
        annonces.first.url,
        "https://www.terrasse-en-ville.com/annonces-immobiliere-marseille/mazargues-appartement-t2-45-m2-terrasse-parking-249-000-",
      );
      expect(annonces.first.agence, "Terrasse en ville");
    });

    test('filtre', () {
      final annonces = TerrasseEnVilleParser().parseHtml(loadTestAssets(path));
      final annoncesFiltrees = AnnoncesFilter().neGardeQueLesAnnoncesValides(annonces);
      expect(annoncesFiltrees.length, 2);
    });
  });

  group('locations', () {
    const path = "terrasse-en-ville-locations.html";
    test('parse', () {
      final annonces = TerrasseEnVilleParser().parseHtml(loadTestAssets(path));
      expect(annonces.length, 2);
      expect(annonces.first.titre, "Vauban - Duplex T5 - Terrasse - 2 400 €");
      expect(
        annonces.first.imageUrl,
        "https://images.squarespace-cdn.com/content/v1/5ac338c57106998b66912a94/1636563794028-2YQGYVCNC80O969WPK7P/terrasse.jpg",
      );
      expect(
        annonces.first.url,
        "https://www.terrasse-en-ville.com/location/vauban-duplex-t5-terrasse-balcon-parking-notredame",
      );
      expect(annonces.first.agence, "Terrasse en ville");
    });

    test('filtre', () {
      final annonces = TerrasseEnVilleParser().parseHtml(loadTestAssets(path));
      final annoncesFiltrees = AnnoncesFilter().neGardeQueLesAnnoncesValides(annonces);
      expect(annoncesFiltrees.length, 2);
    });
  });
}

/*
<div class="summary-thumbnail-outer-container">
    <a
        href="/annonces-immobiliere-marseille/mazargues-appartement-t2-45-m2-terrasse-parking-249-000-"
        class="summary-thumbnail-container sqs-gallery-image-container"
        data-title=" MAZARGUES - APPARTEMENT T2 - 45 M2 - TERRASSE - PARKING - 249 000 €"
        data-description=""
    >
        <div class="summary-thumbnail img-wrapper" data-animation-role="image">
            <!-- Main Image -->
            <img
                data-src="https://images.squarespace-cdn.com/content/v1/5ac338c57106998b66912a94/1632481934077-0XLWFKHRX87IM1Y4J3QG/IMG_9513_4_5_6_7.jpg"
                data-image="https://images.squarespace-cdn.com/content/v1/5ac338c57106998b66912a94/1632481934077-0XLWFKHRX87IM1Y4J3QG/IMG_9513_4_5_6_7.jpg"
                data-image-dimensions="1393x900"
                data-image-focal-point="0.5,0.5"
                alt=" MAZARGUES - APPARTEMENT T2 - 45 M2 - TERRASSE - PARKING - 249 000 €"
                data-load="false"
                class="summary-thumbnail-image"
            />
        </div>
    </a>
</div>
 */
