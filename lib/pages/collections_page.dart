import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подборки'),
      ),
      body: Center(
        child: Text('Подборки фильмов'),
      ),
    );
  }
}