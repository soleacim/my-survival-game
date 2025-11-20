import 'dart:math';

import 'package:first_app_flutter/game/components/components.dart';
import 'package:first_app_flutter/game/utils/AudioManager.dart';
import 'package:first_app_flutter/game/utils/heroes_sprite_preloader.dart';
import 'package:first_app_flutter/game/utils/zombie_sprite_preloader.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'RightPanel.dart';

class SurvivalGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {

  int bullets = 0;
  int score = 0;
  int wave = 1;
  late TextComponent infoComponent;
  bool hasBlood = false;
  bool endOfGame = false;
  Vector2 playerPosition = Vector2.zero();


  SurvivalGame()
      : super(
          children: [
            Background(),
            GunIcon(Vector2(500,500)),
            GunIcon(Vector2(800,500)),
            SwordIcon(Vector2(1000,500)),
          ],
        );



  @override
  Future<void> onLoad() async {
    super.onLoad();

    final sprite = await loadSprite('empty.jpeg');

    add(
      RightPanel(
        label: 'Label',
        iconSprite: sprite,
      ),
    );

    add(FpsTextComponent(position: Vector2(10, 10)));
    //overlays.add('Performance');

    HeroesSpritePreloader heroesSpritePreloader = HeroesSpritePreloader(game: this);
    heroesSpritePreloader.preloadAnimations(4);
    add(Player(size / 2, heroesSpritePreloader));

    final screenSize = size;
    final relativeX = 300.0; //TODO : position relative?
    final relativeY = screenSize.y - 100;

    createInfoComponent('Bullets : $bullets', relativeX, relativeY);
    createInfoComponent('Score : $score', relativeX, relativeY);

    ZombieSpritePreloader zombieSpritePreloader = ZombieSpritePreloader(game: this);
    zombieSpritePreloader.preloadAnimations(4);
    createWave(zombieSpritePreloader);

    // add Text Component
    add(infoComponent);

    AudioManager().preloadSounds();
  }

  void createWave(ZombieSpritePreloader zombieSpritePreloader) {
    print('launch wave!');
    for(int i = 0; i < wave; i++){
      double x = Random().nextDouble() * 200;
      double y = Random().nextDouble() * 200;
      add(Zombie("leZombie", Vector2(computeStartX(x), computeStartY(y)), zombieSpritePreloader));
    }
    if(wave < 4){
      wave = wave * 2;
    }
  }

  void createInfoComponent(String myText, double relativeX, double relativeY) {
    infoComponent = TextComponent(
      text: myText,
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

  void evalNextWave(ZombieSpritePreloader zombieSpritePreloader){
    if(!hasRobot()){
      createWave(zombieSpritePreloader);
    }
  }

  bool hasRobot(){
    for(Component component in children){
      if(component is Zombie && !component.isReallyDead){
        return true;
      }
    }
    print('No have Enemy into the game');
    return false;
  }

  void finishGame(Vector2 lastPosition) async {
    await showBlood(lastPosition);
    showPopup();
    FlameAudio.bgm.stop();
    pauseEngine();
  }

  Future<void> showBlood(Vector2 lastPosition) async {
    Blood endBloood = Blood(lastPosition);
    endBloood.onLoad();
    add(endBloood);
    return Future.delayed(const Duration(seconds: 1));
  }

}
