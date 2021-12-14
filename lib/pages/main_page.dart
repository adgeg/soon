import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:soon/core/annonce.dart';
import 'package:soon/core/mutli_agence_provider.dart';
import 'package:soon/data/skipped_annonces_repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

enum DisplayState { loading, annonces, rienDeNeuf, error }

class _MainPageState extends State<MainPage> {
  final provider = MultiAgencesProvider();
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
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(title: const Center(child: Text("Soon"))),
      body: RefreshIndicator(
        key: UniqueKey(),
        onRefresh: () async => await _refreshAnnonces(),
        child: _content(),
      ),
    );
  }

  void _initSubscription() {
    _subscription = provider.annonces().listen((annonces) {
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
    final listView = ListView.builder(
      itemCount: _displayedAnnonces.length,
      itemBuilder: (BuildContext context, int index) {
        final annonce = _displayedAnnonces[index];
        return _annonce(
          annonce: annonce,
          annonceIndex: index,
          animateAppearance: !_previousDisplayedAnnonces.contains(annonce),
        );
      },
      physics: const AlwaysScrollableScrollPhysics(),
    );
    Future.delayed(const Duration(milliseconds: 50), () => _previousDisplayedAnnonces.addAll(_displayedAnnonces));
    return listView;
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
      key: ValueKey(annonce.url),
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
                Image.network(annonce.imageUrl, height: 240, width: double.infinity, fit: BoxFit.fitWidth),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      color: const Color(0x88000000),
                      child: Center(child: Text(annonce.titre)),
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

  Widget _loader() => const Center(child: CircularProgressIndicator(color: Colors.white));

  Widget _message(IconData icon, String text) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height - 56,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 96),
              Padding(padding: const EdgeInsets.only(top: 16), child: Text(text)),
            ],
          ),
        ),
      ),
    );
  }

  double _beginDelayed({required int annonceIndex, required int animationDuration, required int animationDelay}) {
    /*
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
