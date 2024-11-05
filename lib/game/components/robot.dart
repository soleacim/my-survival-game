import 'package:first_app_flutter/game/components/bullet.dart';
import 'package:first_app_flutter/game/components/player.dart';
import 'package:first_app_flutter/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'blood.dart';

class Robot extends SpriteAnimationComponent
    with HasGameRef<SurvivalGame>, CollisionCallbacks {

  bool isReallyDead = false;
  bool isfocus = false;
  String name;

  Robot(String myName, Vector2 originalPosition)
      : name = myName,
        isfocus = true,
        super(
          position: originalPosition
        );

  static const _speed = 50.0;
  static const _spriteMecha = 'mecha2.png';
  Vector2 _direction = Vector2(0, 0);

  @override
  Future<void> onLoad() async {

    try {
      loadLineFromSprite(0);

      debugMode = true;
      size = Vector2.all(70);
    } catch (e) {
      print("Erreur lors du chargement de l'animation : $e");
    }
    //debugMode = true;
    add(
      RectangleHitbox.relative(
        Vector2(0.6, 0.6),
        parentSize: size,
      ),
    );
  }

  Future<void> goDown() async {
    await loadLineFromSprite(0);
  }

  Future<void> goLeft() async {
    await loadLineFromSprite(1);
  }

  Future<void> goRight() async {
    await loadLineFromSprite(2);
  }

  Future<void> goUp() async {
    await loadLineFromSprite(3);
  }

  Future<void> loadLineFromSprite(int line) async {
    animation = await game.loadSpriteAnimation(
      _spriteMecha,
      SpriteAnimationData.sequenced(
          amount: 4, // Nombre de frames
          stepTime: 0.1, // Temps entre les frames
          textureSize: Vector2(65, 65),
          amountPerRow: 4,
          texturePosition: Vector2(0, line * 65),
          loop: false
      ),
    );
  }

  @override
  void update(double dt) {
    if(gameRef.endOfGame){
      return;
    }
    super.update(dt);

    if(isfocus){
      _direction = computeDirection(position, (gameRef.playerPosition + Vector2(-60, -60)));
      var diff = _direction * _speed * dt;
      position.x += diff.x;
      position.y += diff.y;
    }
  }

  Vector2 computeDirection(Vector2 position, Vector2 playerPosition) {
    return convertToDirection(position - playerPosition);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    print('Collision détectée avec $other');

    if(other is Bullet){
      super.removeFromParent();
      isReallyDead = true;
      gameRef.score++;
      gameRef.updateText();
      gameRef.evalNextWave();
      return;
    }

    if(other is Player){
      isfocus = false;
      gameRef.finishGame(other.position);
    }
  }

  void showBlood(Vector2 lastPosition) {
    Blood endBloood = Blood(lastPosition);
    endBloood.onLoad();
    gameRef.add(endBloood);
  }

  Vector2 convertToDirection(Vector2 diff) {
    if (diff.x.abs() > diff.y.abs() ){
      if(diff.x > 0){
        goLeft();
        return Vector2(-1, 0);
      }else{
        goRight();
        return Vector2(1, 0);
      }
    }else{
      if(diff.y > 0){
        goUp();
        return Vector2(0, -1);
      }else{
        goDown();
        return Vector2(0, 1);
      }
    }
  }

}
