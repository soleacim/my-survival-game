import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:first_app_flutter/game/game.dart';

class Gun extends SpriteComponent with HasGameRef<SurvivalGame>, CollisionCallbacks {
  static const _spriteGun = 'pistolet.png';

  Gun(Vector2 position)
      : super(
    position: position,
    size: Vector2(50, 50),
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Charger le sprite et l'assigner à ce composant
    sprite = await Sprite.load(_spriteGun);

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
   // print('Collision détectée avec $other');
  }

  // @override
  // void onCollisionEnd(PositionComponent other) {
  //   super.onCollisionEnd(other);
  //   print('Fin de la collision avec $other');
  // }
}
