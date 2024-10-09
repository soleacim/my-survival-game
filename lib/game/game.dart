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
