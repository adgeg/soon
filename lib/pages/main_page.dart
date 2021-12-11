import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        title: Center(
          child: Text(
            "Soon",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500, letterSpacing: -0.3),
          ),
        ),
      ),
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
      if (_displayedAnnonces.isNotEmpty) {
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
    return ListView.builder(
      itemCount: _displayedAnnonces.length,
      itemBuilder: (BuildContext context, int index) => _annonce(_displayedAnnonces[index], index),
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget _annonce(Annonce annonce, int annonceIndex) {
    return Dismissible(
      key: ValueKey(annonce.url),
      onDismissed: (direction) {
        setState(() {
          SkippedAnnoncesRepository.skipAnnonce(annonce);
          _displayedAnnonces.removeAt(annonceIndex);
        });
      },
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
                child: Center(
                  child: Text(
                    annonce.titre,
                    style:
                        GoogleFonts.montserrat(fontWeight: FontWeight.w500, letterSpacing: -0.3, color: Colors.white),
                  ),
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
                  launch(annonce.url, customTabsOption: CustomTabsOption(toolbarColor: Theme.of(context).primaryColor));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loader() => const Center(child: CircularProgressIndicator());

  Widget _message(IconData icon, String text) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 1 / 3),
            Icon(
              icon,
              color: Colors.white,
              size: 96,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                text,
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w500, letterSpacing: -0.3, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
