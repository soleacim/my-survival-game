import 'package:first_app_flutter/game/components/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class SurvivalGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  SurvivalGame()
      : super(
          children: [
            Background(),
            Player(),
            Gun(Vector2(500,500)),
            Gun(Vector2(800,500))
          ],
        );

  void tookHit() {
  }

  void restartGame() {
    add(Player());
  }

  void increaseScore() {
  }
}
