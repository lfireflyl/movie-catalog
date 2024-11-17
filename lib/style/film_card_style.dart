import 'package:flutter/material.dart';

class FilmCardStyle {
  static const Color primaryColor = Color(0xFF6200EE);

  static const TextStyle movieTitleStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle movieDescriptionStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.black54,
    height: 1.4,
  );

  static const TextStyle dateStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.grey,
  );

  static const TextStyle ratingStyle = TextStyle(
    fontSize: 18.0,
    color: Colors.amber,
    fontWeight: FontWeight.bold,
  );

  static ButtonStyle backButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Color(0xFF6200EE)),
    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
  );

  static const TextStyle textButtonStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  );
}
