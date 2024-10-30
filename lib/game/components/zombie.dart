import 'package:first_app_flutter/game/components/bullet.dart';
import 'package:first_app_flutter/game/components/player.dart';
import 'package:first_app_flutter/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Zombie extends SpriteAnimationComponent
    with HasGameRef<SurvivalGame>, CollisionCallbacks {

  bool isReallyDead = false;
  String name;

  Zombie(String myName, Vector2 originalPosition)
      : name = myName,
        super(
          position: originalPosition
        );

  static const _speed = 50.0;
  static const _spriteZombie = 'gym-leader-thumbnail-removebg-preview.png';
  Vector2 _direction = Vector2(0, 0);

  @override
  Future<void> onLoad() async {

    try {
      loadLineFromSprite(0);

      size = Vector2.all(40);
    } catch (e) {
      print("Erreur lors du chargement de l'animation : $e");
    }
    debugMode = true;
    add(
      RectangleHitbox.relative(
        Vector2(1, 1),
        parentSize: size,
      ),
    );
  }

  Future<void> loadLineFromSprite(int line) async {
    animation = await game.loadSpriteAnimation(
      _spriteZombie,
      SpriteAnimationData.sequenced(
          amount: 4, // Nombre de frames
          stepTime: 0.1, // Temps entre les frames
          textureSize: Vector2(65, 65),
          amountPerRow: 4,
          texturePosition: Vector2(20, line * 65),
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
    _direction = computeDirection(position, gameRef.playerPosition);
    var diff = _direction * _speed * dt;
    position.x += diff.x;
    position.y += diff.y;
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
      gameRef.finishGame();
    }
  }

  Vector2 convertToDirection(Vector2 diff) {
    if (diff.x.abs() > diff.y.abs() ){
      if(diff.x > 0){
        return Vector2(-1, 0);
      }else{
        return Vector2(1, 0);
      }
    }else{
      if(diff.y > 0){
        return Vector2(0, -1);
      }else{
        return Vector2(0, 1);
      }
    }
  }

}
