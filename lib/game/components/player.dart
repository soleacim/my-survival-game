import 'dart:developer';

import 'package:first_app_flutter/game/components/bullet.dart';
import 'package:first_app_flutter/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import 'gun.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef<SurvivalGame>, CollisionCallbacks {

  Player()
      : super(
          anchor: Anchor.center,
        );

  static const _speed = 200.0;
  static const upLimitX = 1500.0;
  static const downLimitX = 500.0;
  static const upLimitY = 750.0;
  static const downLimitY = 250.0;
  static const _sprite_hero = 'gym-leader-thumbnail-removebg-preview.png';
  final _direction = Vector2.zero();
  Vector2 lastDirection = Vector2.zero();

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
            log('arrowLeft !');
            _direction.x = 0;
            return false;
          },
          LogicalKeyboardKey.arrowRight: (_) {
            log('arrowRight !');
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
              var maposition = position + getBulletStart(getBulletDirection(_direction, lastDirection)) * 10;
              var madirection = getBulletDirection(_direction, lastDirection);
              print('new Bullet { position : $maposition, direction : $madirection }');
              gameRef.add(
                  Bullet(
                      position + getBulletStart(getBulletDirection(_direction, lastDirection)) * 10,
                      getBulletDirection(_direction, lastDirection)
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
            goLeft();
            return false;
          },
          LogicalKeyboardKey.arrowRight: (_) {
            _direction.x = 1;
            lastDirection = Vector2(1, 0);
            goRight();
            return false;
          },
          LogicalKeyboardKey.arrowUp: (_) {
            _direction.y = -1;
            lastDirection = Vector2(0, -1);
            goUp();
            return false;
          },
          LogicalKeyboardKey.arrowDown: (_) {
            _direction.y = 1;
            lastDirection = Vector2(0, 1);
            goDown();
            return false;
          },
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
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    //print('Collision détectée avec $other');
    if(other is Gun){
      gameRef.bullets = 50;
      gameRef.updateText();
    }
  }

  Vector2 getBulletDirection(Vector2 direction, Vector2 lastDirection) {
    return direction == Vector2.zero() ? lastDirection : direction;
  }

  Vector2 getBulletStart(Vector2 direction) {
    return Vector2(direction.x * 40, direction.y * 40);
  }

}
