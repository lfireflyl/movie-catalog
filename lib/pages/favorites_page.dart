import 'package:flutter/material.dart';


class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранное'),
      ),
      body: Center(
        child: Text('Избранные фильмы'),
      ),
    );
  }
}