import 'dart:developer';

import 'package:first_app_flutter/game/components/bullet.dart';
import 'package:first_app_flutter/game/components/components.dart';
import 'package:first_app_flutter/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'gun.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<SurvivalGame>, CollisionCallbacks {

  Player(Vector2 myposition)
      : super(
          position: myposition,
          anchor: Anchor.center,
        );

  static const _speed = 100.0;
  static const upLimitX = 1500.0;
  static const downLimitX = 500.0;
  static const upLimitY = 750.0;
  static const downLimitY = 250.0;
  static const _sprite_hero = 'gym-leader-thumbnail-removebg-preview.png';
  final _direction = Vector2.zero();
  Vector2 lastDirection = Vector2.zero();
  double bulletAngle = 0;

  @override
  Future<void> onLoad() async {

    await goDown();

    size = Vector2.all(40);

    add(
      RectangleHitbox.relative(
        Vector2(1, 1),
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
          LogicalKeyboardKey.space: (_) {
            if(game.bullets > 0){
              gameRef.add(
                  Bullet(
                      position + getBulletStart(getBulletDirection(_direction, lastDirection)),
                      getBulletDirection(_direction, lastDirection),
                      bulletAngle
                  )
              );
              gameRef.bullets--;
              gameRef.updateText();
            }
            return false;
          }
        },
        keyDown: {
          LogicalKeyboardKey.arrowLeft: (_) {
            _direction.x = -1;
            lastDirection = Vector2(-1, 0);
            bulletAngle = 3 * math.pi / 2;
            goLeft();
            return false;
          },
          LogicalKeyboardKey.arrowRight: (_) {
            _direction.x = 1;
            lastDirection = Vector2(1, 0);
            bulletAngle = math.pi / 2;
            goRight();
            return false;
          },
          LogicalKeyboardKey.arrowUp: (_) {
            _direction.y = -1;
            lastDirection = Vector2(0, -1);
            bulletAngle = 0;
            goUp();
            return false;
          },
          LogicalKeyboardKey.arrowDown: (_) {
            _direction.y = 1;
            lastDirection = Vector2(0, 1);
            bulletAngle = math.pi;
            goDown();
            return false;
          },
        },
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
      _sprite_hero,
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
    super.update(dt);

    var diff = _direction * _speed * dt;
    var tmp = position + diff;

    if(tmp.x > upLimitX) {
      position.x = upLimitX;
    } else if(tmp.x < downLimitX){
      position.x = downLimitX;
    } else {
      position.x += diff.x;
    }

    if(tmp.y > upLimitY){
      position.y = upLimitY;
    } else if(tmp.y < downLimitY){
      position.y = downLimitY;
    } else {
      position.y += diff.y;
    }

    gameRef.playerPosition = position;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    //print('Collision détectée avec $other');
    if(other is Gun){
      gameRef.bullets = 50;
      gameRef.updateText();
    } else if (other is Robot){
      animation = null;
    }
  }

  Vector2 getBulletDirection(Vector2 direction, Vector2 lastDirection) {
    return direction == Vector2.zero() ? lastDirection : direction;
  }

  Vector2 getBulletStart(Vector2 direction) {
    return Vector2(direction.x * 30, direction.y * 20);
  }

}
