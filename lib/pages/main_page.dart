import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soon/core/annonce.dart';
import 'package:soon/core/mutli_agence_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

enum DisplayState { loading, annonces, error }

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
      appBar: AppBar(
        title: Center(
          child: Text(
            "Soon",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500, letterSpacing: -0.3),
          ),
        ),
      ),
      body: _content(),
    );
  }

  void _initSubscription() {
    _subscription = provider.annonces().listen((annonces) {
      _displayedAnnonces.addAll(annonces);
      _displayState = DisplayState.annonces;
      setState(() {});
    });
    _subscription.onError((_) {
      _displayState = DisplayState.error;
      setState(() {});
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
      case DisplayState.error:
        return _error();
    }
  }

  Widget _annonces() {
    return RefreshIndicator(
      key: UniqueKey(),
      onRefresh: () async {
        await _refreshAnnonces();
        return;
      },
      child: ListView.builder(
        itemCount: _displayedAnnonces.length,
        itemBuilder: (BuildContext context, int index) => _annonce(_displayedAnnonces[index]),
      ),
    );
  }

  Widget _annonce(Annonce annonce) {
    return Stack(
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
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.3,
                    color: Colors.white,
                  ),
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
    );
  }

  Center _loader() => const Center(child: CircularProgressIndicator());

  Center _error() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.error_outline, color: Colors.red),
          Padding(padding: EdgeInsets.only(top: 16), child: Text('Oups, pas cette fois ci…')),
        ],
      ),
    );
  }
}
