import 'package:first_app_flutter/game/components/components.dart';
import 'package:first_app_flutter/game/utils/AudioManager.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:first_app_flutter/game/game.dart';

class Bullet extends SpriteComponent with HasGameRef<SurvivalGame>, CollisionCallbacks {
  static const _spriteBullet = 'bullet.png';
  Vector2 _bulletDirection;
  Vector2 positionInitial;

  Bullet(Vector2 positionOrigin, Vector2 directionOrigin, double angleOrigin)
      :
        _bulletDirection = directionOrigin,
        positionInitial = positionOrigin,
        super(
        angle: angleOrigin,
        position: positionOrigin,
        size: Vector2(20, 20),
      );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Charger le sprite et l'assigner à ce composant
    sprite = await Sprite.load(_spriteBullet);

    AudioManager().playPanSound();

    //debugMode = true;
    // Ajouter une hitbox ou d'autres configurations si nécessaire
    add(RectangleHitbox.relative(
      Vector2(0.7, 0.5),
      parentSize: size,
    )
      ..collisionType = CollisionType.active);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is! Player){
      super.removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Mise à jour de la position de l'objet en fonction de sa vélocité
    position += _bulletDirection * 20;

    // if (isOffScreen(position)) {
    //   super.removeFromParent();
    // }
    if(position.distanceTo(positionInitial) > 1000){
      super.removeFromParent();
    }
  }

  // bool isOffScreen(Vector2 position) {
  //   if(position.x < 0){
  //     return true;
  //   } else if(position.x > gameRef.size.x){
  //     return true;
  //   } else if(position.y < 0){
  //     return true;
  //   } else if(position.y > gameRef.size.y){
  //     return true;
  //   }
  //   return false;
  // }

  // @override
  // void onCollisionEnd(PositionComponent other) {
  //   super.onCollisionEnd(other);
  //   print('Fin de la collision avec $other');
  // }
}
