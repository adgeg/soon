import 'package:flutter_test/flutter_test.dart';
import 'package:soon/ma_terrasse_a_marseille/ma_terrasse_a_marseille_filter.dart';
import 'package:soon/ma_terrasse_a_marseille/ma_terrasse_a_marseille_parser.dart';

import 'test_assets.dart';

void main() {
  group('achats', () {
    const path = "ma-terrasse-a-marseille.html";
    test('parse', () {
      final annonces = MaTerrasseAMarseilleParser().parseHtml(loadTestAssets(path));
      expect(annonces.length, 21);
      expect(annonces.first.titre, "« I have a Dream !  » ………..Malmousque - 2 000 000 €");
      expect(annonces.first.statut, "À Vendre");
      expect(annonces.first.prix, 2000000);
      expect(
        annonces.first.imageUrl,
        "https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-488x326.jpg",
      );
      expect(annonces.first.url, "https://materrasseamarseille.com/bien/i-have-a-dream-malmousque/");
      expect(annonces.first.agence, "Ma terrasse à Marseille");
    });

    test('filtre ne garde que les annonces à vendre inférieures à 500 000€', () {
      final annonces = MaTerrasseAMarseilleParser().parseHtml(loadTestAssets(path));
      final annoncesFiltrees = MaTerrasseAMarseilleFilter().neGardeQueLesAnnoncesValides(annonces);
      expect(annoncesFiltrees.length, 6);
    });
  });
}

/*

<div class="wrapper_properties_ele">
    <article
        class="rh_prop_card_elementor post-13206 property type-property status-publish has-post-thumbnail hentry property-feature-vues-imprenables-sur-mer property-type-maison-vue-mer property-city-201 property-city-malmousque property-status-vente rh_blog__post entry-header-margin-fix"
    >
        <div class="rh_prop_card__wrap">
            <div class="rh_label_elementor rh_label__property_elementor">
                <div class="rh_label__wrap">A la une <span></span></div>
            </div>

            <figure class="rh_prop_card__thumbnail">
                <div class="rhea_figure_property_one">
                    <a href="https://materrasseamarseille.com/bien/i-have-a-dream-malmousque/">
                        <img
                            width="488"
                            height="326"
                            src="https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-488x326.jpg"
                            class="attachment-property-thumb-image size-property-thumb-image wp-post-image"
                            alt=""
                            loading="lazy"
                            srcset="
                                https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-488x326.jpg    488w,
                                https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-1280x853.jpg  1280w,
                                https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-768x512.jpg    768w,
                                https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-1536x1023.jpg 1536w,
                                https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-2048x1364.jpg 2048w,
                                https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-500x333.jpg    500w,
                                https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-150x100.jpg    150w,
                                https://materrasseamarseille.com/wp-content/uploads/2021/10/plateau-de-malmousque-13007-8-1320x879.jpg  1320w
                            "
                            sizes="(max-width: 488px) 100vw, 488px"
                        />
                    </a>

                    <div class="rh_overlay"></div>
                    <div class="rh_overlay__contents rh_overlay__fadeIn-bottom">
                        <a href="https://materrasseamarseille.com/bien/i-have-a-dream-malmousque/">Voir le bien </a>
                    </div>
                    <span style="background: ;" class="rhea-property-label">Exclusivité</span>
                </div>

                <div class="rh_prop_card__btns"></div>
            </figure>

            <div class="rh_prop_card__details_elementor">
                <h3><a href="https://materrasseamarseille.com/bien/i-have-a-dream-malmousque/">« I have a Dream !  » &#8230;&#8230;&#8230;..Malmousque</a></h3>
                <p class="rh_prop_card__excerpt addressanchor">
                    <a href="https://materrasseamarseille.com/bien/i-have-a-dream-malmousque/#mapp">
                        <i style="padding-right: 5px; color: #000;" class="fas fa-map-marker-alt"></i>1 Plt de Malmousque, 13007 Marseille, France<span style="color: #000; font-style: normal;"> | voir sur la carte</span>
                    </a>
                </p>

                <p class="rh_prop_card__excerpt">À la pointe de Malmousque, surplombant les bains Militaires, la Légion et le Port de&hellip;</p>

                <div class="rh_prop_card__meta_wrap_elementor">
                    <div class="rh_prop_card_meta_wrap_stylish">
                        <div class="rh_prop_card__meta">
                            <span class="rhea_meta_titles">Chambres</span>
                            <div class="rhea_meta_icon_wrapper">
                                <svg class="rh_svg" xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
                                    <defs></defs>
                                    <path
                                        d="M1111.91,600.993h16.17a2.635,2.635,0,0,1,2.68,1.773l1.21,11.358a2.456,2.456,0,0,1-2.61,2.875h-18.73a2.46,2.46,0,0,1-2.61-2.875l1.21-11.358A2.635,2.635,0,0,1,1111.91,600.993Zm0.66-7.994h3.86c1.09,0,2.57.135,2.57,1l0.01,3.463c0.14,0.838-1.72,1.539-2.93,1.539h-4.17c-1.21,0-2.07-.7-1.92-1.539l0.37-3.139A2.146,2.146,0,0,1,1112.57,593Zm11,0h3.86a2.123,2.123,0,0,1,2.2,1.325l0.38,3.139c0.14,0.838-.72,1.539-1.93,1.539h-5.17c-1.21,0-2.07-.7-1.92-1.539L1121,594C1121,593.1,1122.48,593,1123.57,593Z"
                                        transform="translate(-1108 -593)"
                                    />
                                </svg>
                                <span class="figure">5</span>
                            </div>
                        </div>
                        <div class="rh_prop_card__meta">
                            <span class="rhea_meta_titles">Salle de bains</span>
                            <div class="rhea_meta_icon_wrapper">
                                <svg class="rh_svg" xmlns="http://www.w3.org/2000/svg" width="23.69" height="24" viewBox="0 0 23.69 24">
                                    <path
                                        d="M1204,601a8,8,0,0,1,16,0v16h-2V601a6,6,0,0,0-12,0v1h-2v-1Zm7,6a6,6,0,0,0-12,0h12Zm-6,2a1,1,0,0,1,1,1v1a1,1,0,0,1-2,0v-1A1,1,0,0,1,1205,609Zm0,5a1,1,0,0,1,1,1v1a1,1,0,0,1-2,0v-1A1,1,0,0,1,1205,614Zm4.94-5.343a1,1,0,0,1,1.28.6l0.69,0.878a1,1,0,0,1-1.88.685l-0.69-.879A1,1,0,0,1,1209.94,608.657Zm2.05,4.638a1,1,0,0,1,1.28.6l0.35,0.94a1.008,1.008,0,0,1-.6,1.282,1,1,0,0,1-1.28-.6l-0.35-.939A1.008,1.008,0,0,1,1211.99,613.295Zm-11.93-4.638a1,1,0,0,1,.6,1.282l-0.69.879a1,1,0,1,1-1.87-.682l0.68-.88A1,1,0,0,1,1200.06,608.657Zm-2.05,4.639a1,1,0,0,1,.6,1.281l-0.34.941a1,1,0,0,1-1.88-.683l0.34-.94A1,1,0,0,1,1198.01,613.3Z"
                                        transform="translate(-1196.31 -593)"
                                    />
                                </svg>
                                <span class="figure">4</span>
                            </div>
                        </div>
                        <div class="rh_prop_card__meta">
                            <span class="rhea_meta_titles">Surface</span>
                            <div class="rhea_meta_icon_wrapper">
                                <svg
                                    class="rh_svg"
                                    version="1.1"
                                    xmlns="http://www.w3.org/2000/svg"
                                    xmlns:xlink="http://www.w3.org/1999/xlink"
                                    x="0px"
                                    y="0px"
                                    width="24px"
                                    height="24px"
                                    viewBox="0 0 24 24"
                                    enable-background="new 0 0 24 24"
                                    xml:space="preserve"
                                >
                                    <g>
                                        <circle cx="2" cy="2" r="2" />
                                    </g>
                                    <g>
                                        <circle cx="2" cy="22" r="2" />
                                    </g>
                                    <g>
                                        <circle cx="22" cy="2" r="2" />
                                    </g>
                                    <rect x="1" y="1" width="2" height="22" />
                                    <rect x="1" y="1" width="22" height="2" />
                                    <path
                                        opacity="0.5"
                                        d="M23,20.277V1h-2v19.277C20.7,20.452,20.452,20.7,20.277,21H1v2h19.277c0.347,0.596,0.984,1,1.723,1
	c1.104,0,2-0.896,2-2C24,21.262,23.596,20.624,23,20.277z"
                                    />
                                </svg>
                                <span class="figure">150</span>
                                <span class="label">m²</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="rh_prop_card__priceLabel">
                    <div class="rhea_property_price_box">
                        <span class="rh_prop_card__status"> À Vendre </span>
                        <p class="rh_prop_card__price">
                            2 000 000 €
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </article>
    <!-- /.rh_prop_card -->
</div>

 */
