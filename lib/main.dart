import 'package:flutter/material.dart';
import 'package:first_app_flutter/title_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      home: TitleScreen(),
    ),
  );
}
