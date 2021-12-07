import 'package:flutter/material.dart';
import 'package:soon/core/annonce.dart';
import 'package:soon/terrasse_en_ville/terrasse_en_ville_use_case.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Soon")),
      body: FutureBuilder(
        future: TerrasseEnVilleUseCase().annonces(),
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            final List<Annonce> annonces = snapshot.data as List<Annonce>;
            child = ListView.builder(
              itemCount: annonces.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(annonces[index].titre),
                );
              },
            );
          } else if (snapshot.hasError) {
            child = Center(
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
          } else {
            child = const Center(child: CircularProgressIndicator());
          }
          return child;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {}),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
