import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soon/core/annonce.dart';
import 'package:soon/terrasse_en_ville/terrasse_en_ville_use_case.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final useCase = TerrasseEnVilleUseCase();
  late Future<List<Annonce>> _annonces;

  @override
  void initState() {
    super.initState();
    _annonces = useCase.annonces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text("Soon", style: GoogleFonts.montserrat(fontWeight: FontWeight.w500, letterSpacing: -0.3)),
      )),
      body: FutureBuilder(
        future: _annonces,
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            final List<Annonce> annonces = snapshot.data as List<Annonce>;
            child = _contenu(context, annonces);
          } else if (snapshot.hasError) {
            child = _erreur(snapshot);
          } else {
            child = _loader();
          }
          return child;
        },
      ),
    );
  }

  Widget _contenu(BuildContext context, List<Annonce> annonces) {
    return RefreshIndicator(
      key: UniqueKey(),
      onRefresh: () async {
        await _refreshAnnonces();
        return;
      },
      child: ListView.builder(
        itemCount: annonces.length,
        itemBuilder: (BuildContext context, int index) => _annonce(context, annonces[index]),
      ),
    );
  }

  Future<void> _refreshAnnonces() async {
    _annonces = Future.value(await useCase.annonces());
    setState(() {});
    return;
  }

  Widget _annonce(BuildContext context, Annonce annonce) {
    return Stack(
      children: [
        Image.network(annonce.imageUrl),
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

  Center _erreur(AsyncSnapshot<Object?> snapshot) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: ${snapshot.error}'),
          ),
        ],
      ),
    );
  }
}
