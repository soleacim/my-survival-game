import 'package:first_app_flutter/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Zombie extends SpriteAnimationComponent
    with HasGameRef<SurvivalGame>, CollisionCallbacks {

  Zombie(Anchor anchorInitial)
      : super(
          anchor: anchorInitial,
        );

  static const _speed = 100.0;
  static const _spriteZombie = 'zombie.png';
  final _direction = Vector2.zero();

  @override
  Future<void> onLoad() async {

    try {
      animation = await game.loadSpriteAnimation(
        _spriteZombie,
        SpriteAnimationData.sequenced(
            amount: 4, // Nombre de frames
            stepTime: 0.1, // Temps entre les frames
            textureSize: Vector2(65, 65),
            amountPerRow: 4,
            texturePosition: Vector2(100, 65),
            loop: false
        ),
      );

      size = Vector2.all(100);
      position = gameRef.size / 3;
    } catch (e) {
      print("Erreur lors du chargement de l'animation : $e");
    }

    // add(
    //   RectangleHitbox.relative(
    //     Vector2(0.8, 0.8),
    //     parentSize: size,
    //   ),
    // );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // var diff = _direction * _speed * dt;
    // position.x += diff.x;
    // position.y += diff.y;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    print('Collision détectée avec $other');
    // if(other is Gun){
    //   gameRef.bullets = 50;
    //   gameRef.updateText();
    // }
  }

}
