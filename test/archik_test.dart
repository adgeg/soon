import 'package:flutter_test/flutter_test.dart';
import 'package:soon/agences/archik/archik_parser.dart';

import 'test_assets.dart';

void main() {
  group('achats', () {
    const path = "archik.html";
    test('parse', () {
      final annonces = ArchikParser().parseHtml(loadTestAssets(path));
      expect(annonces.length, 8);
      expect(annonces.first.titre, "MARSEILLE 9ÈME | Mazargues - 290 000 €");
      expect(annonces.first.prix, 290000);
      expect(
        annonces.first.imageUrl,
        "https://archik.fr/wp-content/uploads/2021/12/ARCHIK-appartement-marseille-mazargues-blanc-neige-OP1061-cover.jpg",
      );
      expect(annonces.first.url, "https://archik.fr/biens/blanc-neige/");
      expect(annonces.first.agence, "Archik");
    });
  });
}

/*
<div class="singlebien">
   <div class="photobien">
       <div class="imgquart"
            style="background-image:url(https://archik.fr/wp-content/uploads/2021/12/ARCHIK-appartement-marseille-mazargues-blanc-neige-OP1061-cover.jpg);">
           <a href="https://archik.fr/biens/blanc-neige/"></a></div>
       <div class="imgquart second"
            style="background-image:url(https://archik.fr/wp-content/uploads/2021/12/ARCHIK-appartement-marseille-mazargues-blanc-neige-OP1061-last.jpg);">
           <a href="https://archik.fr/biens/blanc-neige/"></a></div>
   </div>
   <div class="bottombien">
       <div class="leftbien"><p class="nameadd">BLANC NEIGE</p>
           <p class="arrondissementbien">MARSEILLE 9ÈME | Mazargues</p></div>
       <div class="rightbien"><p class="pricebien">290 000 €</p>
           <button class="simplefavorite-button" data-postid="27793"
                   data-siteid="1" data-groupid="1" data-favoritecount="1"
                   style="">
               <div class="addfavorite">
                   <div>
           </button>
       </div>
   </div>
</div>
 */
