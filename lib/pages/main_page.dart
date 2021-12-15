import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:soon/core/annonce.dart';
import 'package:soon/core/mutli_agence_provider.dart';
import 'package:soon/data/skipped_annonces_repository.dart';
import 'package:transparent_image/transparent_image.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

enum DisplayState { loading, annonces, rienDeNeuf, error }

class _MainPageState extends State<MainPage> {
  final MultiAgencesProvider _provider = MultiAgencesProvider();
  final List<Annonce> _displayedAnnonces = [];
  final List<Annonce> _previousDisplayedAnnonces = [];
  late StreamSubscription _subscription;
  late DisplayState _displayState;

  @override
  void initState() {
    super.initState();
    _displayState = DisplayState.loading;
    _initSubscription();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter, // 10% of the width, so there are ten blinds.
              stops: [0, 0.6, 1],
              colors: [
                Color(0xFFFF5678),
                Color(0xFF5200FF),
                Color(0xFF0094FF),
              ], // red to yellow
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(-400, 0),
          child: Transform.rotate(
            angle: -3.14159 / 5.5,
            child: Transform.scale(
              scale: 2,
              child: Container(color: const Color(0x0FFFFFFF)),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: const SliverAppBar(
                    title: Center(child: Text("Soon")),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                )
              ];
            },
            body: Builder(
              builder: (context) {
                return RefreshIndicator(
                  onRefresh: () async => await _refreshAnnonces(),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                      _content(),
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  void _initSubscription() {
    _subscription = _provider.annonces().listen((annonces) {
      _displayedAnnonces.addAll(annonces);
      if (annonces.isNotEmpty) {
        _displayState = DisplayState.annonces;
        setState(() {});
      }
    });
    _subscription.onError((_) {
      _displayState = DisplayState.error;
      setState(() {});
    });
    _subscription.onDone(() {
      if (_displayedAnnonces.isEmpty) {
        _displayState = DisplayState.rienDeNeuf;
        setState(() {});
      }
    });
  }

  Future<void> _refreshAnnonces() async {
    _displayedAnnonces.clear();
    _previousDisplayedAnnonces.clear();
    _subscription.cancel();
    _initSubscription();
    return;
  }

  Widget _content() {
    switch (_displayState) {
      case DisplayState.loading:
        return _loader();
      case DisplayState.annonces:
        return _annonces();
      case DisplayState.rienDeNeuf:
        return _message(Icons.lock_clock, "Pas cette fois-ci non…");
      case DisplayState.error:
        return _message(Icons.error_outline, "A donde esta el réseau por favor?");
    }
  }

  Widget _annonces() {
    Future.delayed(const Duration(milliseconds: 0), () => _previousDisplayedAnnonces.addAll(_displayedAnnonces));
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final annonce = _displayedAnnonces[index];
          return _annonce(
            annonce: annonce,
            annonceIndex: index,
            animateAppearance: !_previousDisplayedAnnonces.contains(annonce),
          );
        },
        childCount: _displayedAnnonces.length,
      ),
    );
  }

  Widget _annonce({required Annonce annonce, required int annonceIndex, required bool animateAppearance}) {
    const int animationDuration = 400;
    const int animationDelay = animationDuration ~/ 2;
    final animationDurationForAnnonce = _animationDurationForAnnonce(
      animateAppearance: animateAppearance,
      animationDuration: animationDuration,
      annonceIndex: annonceIndex,
      animationDelay: animationDelay,
    );
    return Dismissible(
      key: Key(annonce.url),
      onDismissed: (direction) {
        setState(() {
          SkippedAnnoncesRepository.skipAnnonce(annonce);
          _displayedAnnonces.removeAt(annonceIndex);
        });
      },
      child: TweenAnimationBuilder<double>(
        duration: animationDurationForAnnonce,
        curve: Interval(
          _beginDelayed(
            annonceIndex: annonceIndex,
            animationDuration: animationDuration,
            animationDelay: animationDelay,
          ),
          1,
          curve: Curves.fastOutSlowIn,
        ),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          return AnimatedOpacity(
            duration: animationDurationForAnnonce,
            opacity: value,
            child: Stack(
              children: [
                FadeInImage.memoryNetwork(
                  image: annonce.imageUrl,
                  placeholder: kTransparentImage,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 48,
                      child: Stack(
                        children: [
                          ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(color: const Color(0x88FFFFFF)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Center(child: Text(annonce.titre, style: Theme.of(context).textTheme.bodyText1)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: const Color(0x11000000),
                      onTap: () {
                        launch(annonce.url,
                            customTabsOption: CustomTabsOption(toolbarColor: Theme.of(context).primaryColor));
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _loader() => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: Colors.white)));

  Widget _message(IconData icon, String text) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 56,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 96),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(text, style: Theme.of(context).textTheme.headline5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _beginDelayed({required int annonceIndex, required int animationDuration, required int animationDelay}) {
    /*
    Si animationDuration = 400 et animationDelay = 200, alors :
    [0] durée : 400   0 -> 400 => 400/400 begin = 1 - 400/400
    [1] durée : 600   0 -> 200 puis animation de 200 à  600 => Interval begin = 1 - 400/600
    [2] durée : 800   0 -> 400 puis animation de 400 à  800 => Interval begin = 1 - 400/800
    [3] durée : 1000  0 -> 600 puis animation de 600 à  1000 => Interval begin = 1 - 400/1000
     */
    return 1 - (animationDuration / (animationDuration + (annonceIndex * animationDelay)));
  }

  Duration _animationDurationForAnnonce({
    required bool animateAppearance,
    required int annonceIndex,
    required int animationDuration,
    required int animationDelay,
  }) {
    return animateAppearance
        ? Duration(milliseconds: animationDuration + annonceIndex * animationDelay)
        : const Duration(seconds: 0);
  }
}
