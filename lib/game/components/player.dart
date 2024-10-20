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
  static const _sprite_hero = 'gym-leader-thumbnail.jpg';
  final _direction = Vector2.zero();

  @override
  Future<void> onLoad() async {

    await goDown();

    size = Vector2.all(40);
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
            goLeft();
            return false;
          },
          LogicalKeyboardKey.arrowRight: (_) {
            _direction.x = 1;
            goRight();
            return false;
          },
          LogicalKeyboardKey.arrowUp: (_) {
            _direction.y = -1;
            goUp();
            return false;
          },
          LogicalKeyboardKey.arrowDown: (_) {
            _direction.y = 1;
            goDown();
            return false;
          },
          LogicalKeyboardKey.space: (_) => false,
        },
      ),
    );
  }

  Future<void> goDown() async {
    var line = 0;
    await loadLineFromSprite(line);
  }

  Future<void> goLeft() async {
    var line = 1;
    await loadLineFromSprite(line);
  }

  Future<void> goRight() async {
    var line = 2;
    await loadLineFromSprite(line);
  }

  Future<void> goUp() async {
    var line = 3;
    await loadLineFromSprite(line);
  }

  Future<void> loadLineFromSprite(int line) async {
    animation = await game.loadSpriteAnimation(
      _sprite_hero,
      SpriteAnimationData.sequenced(
        amount: 4, // Nombre de frames
        stepTime: 0.2, // Temps entre les frames
        textureSize: Vector2(65, 65),
        amountPerRow: 4,
        texturePosition: Vector2(20, line * 65),
        loop: false
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += _direction * _speed * dt;
  }
}
