import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:first_app_flutter/game/game.dart';

class Bullet extends SpriteComponent with HasGameRef<SurvivalGame>, CollisionCallbacks {
  static const _spriteBullet = 'bullet.png';
  Vector2 _bulletDirection = Vector2.zero();

  Bullet(Vector2 positionOrigin, Vector2 directionOrigin, double angleOrigin)
      :
        _bulletDirection = Vector2(directionOrigin.x, directionOrigin.y),
        super(
        angle: angleOrigin,
        position: positionOrigin,
        size: Vector2(20, 20),
      )
  ;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Charger le sprite et l'assigner à ce composant
    sprite = await Sprite.load(_spriteBullet);

    //debugMode = true;
    // Ajouter une hitbox ou d'autres configurations si nécessaire
    add(RectangleHitbox.relative(
      Vector2(0.5, 0.3),
      parentSize: size,
    )
      ..collisionType = CollisionType.active);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    super.removeFromParent();
    //print('Collision détectée avec $other');
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Mise à jour de la position de l'objet en fonction de sa vélocité
    position += _bulletDirection * 10;
  }

  // @override
  // void onCollisionEnd(PositionComponent other) {
  //   super.onCollisionEnd(other);
  //   print('Fin de la collision avec $other');
  // }
}
