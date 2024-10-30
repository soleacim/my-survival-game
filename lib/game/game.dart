import 'dart:math';

import 'package:first_app_flutter/game/components/components.dart';
import 'package:first_app_flutter/game/components/zombie.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class SurvivalGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {

  int bullets = 0;
  int score = 0;
  int wave = 1;
  late TextComponent infoComponent;
  bool endOfGame = false;
  Vector2 playerPosition = Vector2.zero();

  SurvivalGame()
      : super(
          children: [
            Background(),
            Gun(Vector2(500,500)),
            Gun(Vector2(800,500)),
          ],
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(Player(size / 2));

    final screenSize = size;
    final relativeX = 300.0; //TODO : position relative?
    final relativeY = screenSize.y - 100;

    createInfoComponent(relativeX, relativeY);

    createWave();

    // add Text Component
    add(infoComponent);
    
  }

  void createWave() {
    print('launch wave!');
    for(int i = 0; i < wave; i++){
      double x = Random().nextDouble() * 200;
      double y = Random().nextDouble() * 200;
      add(Zombie("leZombie", Vector2(computeStartX(x), computeStartY(y))));
    }
    wave++;
  }

  void createInfoComponent(double relativeX, double relativeY) {
    infoComponent = TextComponent(
      text: 'Bullets : $bullets, Score : $score',
      position: Vector2(relativeX, relativeY),
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );
  }

  void updateText() {
    infoComponent.text = 'Bullets : $bullets, Score : $score';
  }

  void showPopup() {
    overlays.add('GameOver');
  }

  void hidePopup() {
    overlays.remove('GameOver');
  }

  void finishGame() {
    showPopup();
    pauseEngine();
  }

  void restart() {
    overlays.remove('GameOver');
    resumeEngine();
  }

  double computeStartX(double value) {
    if(value < 100.0){
      return value + 100;
    } else {
      return size.x - value;
    }
  }

  double computeStartY(double value) {
    if(value < 100.0){
      return value + 100;
    } else {
      return size.y - value;
    }
  }

  void evalNextWave(){
    if(!hasZombie()){
      createWave();
    }
  }

  bool hasZombie(){
    for(Component component in children){
      if(component is Zombie && !component.isReallyDead){
        return true;
      }
    }
    print('No have Zombie into the game');
    return false;
  }

}
