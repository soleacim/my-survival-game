import 'package:first_app_flutter/game/components/components.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class SurvivalGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {

  int bullets = 0;
  late TextComponent textComponent;

  SurvivalGame()
      : super(
          children: [
            Background(),
            Player(),
            Gun(Vector2(500,500)),
            Gun(Vector2(800,500))
          ],
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final screenSize = size;
    final relativeX = 300.0; // 50% de la largeur de l'écran
    final relativeY = screenSize.y - 100;

    // Créer le composant de texte
    textComponent = TextComponent(
      text: 'Bullets : $bullets',
      position: Vector2(relativeX, relativeY), // Position du texte à l'écran
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );

    // Ajouter le texte au jeu
    add(textComponent);

  }

  void updateText() {
    textComponent.text = 'Bullets : $bullets';
  }

  void tookHit() {
  }

  void restartGame() {
    add(Player());
  }

  void increaseScore() {
  }


}
