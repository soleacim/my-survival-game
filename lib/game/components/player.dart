import 'package:first_app_flutter/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:first_app_flutter/game/components/components.dart';
import 'package:first_app_flutter/game/game.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<SurvivalGame>, CollisionCallbacks {

  Player()
      : super(
          anchor: Anchor.center,
        );

  static const _speed = 400.0;
  final _direction = Vector2.zero();

  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation(
      'fallout_boy3.png',
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.2,
        textureSize: Vector2.all(300),
      ),
    );

    size = Vector2.all(96);
    position = gameRef.size / 2;

    add(
      RectangleHitbox.relative(
        Vector2(0.8, 0.8),
        parentSize: size,
      ),
    );

    add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.arrowLeft: (_) {
            _direction.x = 0;
            return false;
          },
          LogicalKeyboardKey.arrowRight: (_) {
            _direction.x = 0;
            return false;
          },
          LogicalKeyboardKey.arrowUp: (_) {
            _direction.y = 0;
            return false;
          },
          LogicalKeyboardKey.arrowDown: (_) {
            _direction.y = 0;
            return false;
          },
          // LogicalKeyboardKey.space: (_) {
          //   _shoot();
          //   return false;
          // },
        },
        keyDown: {
          LogicalKeyboardKey.arrowLeft: (_) {
            _direction.x = -1;
            return false;
          },
          LogicalKeyboardKey.arrowRight: (_) {
            _direction.x = 1;
            return false;
          },
          LogicalKeyboardKey.arrowUp: (_) {
            _direction.y = -1;
            return false;
          },
          LogicalKeyboardKey.arrowDown: (_) {
            _direction.y = 1;
            return false;
          },
          LogicalKeyboardKey.space: (_) => false,
        },
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += _direction * _speed * dt;
  }
}
