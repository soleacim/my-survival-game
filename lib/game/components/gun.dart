
import 'dart:ui';

import 'package:first_app_flutter/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';


class Gun extends SpriteComponent with HasGameRef<SurvivalGame>, CollisionCallbacks {

  static const _sprite_gun = 'pistolet.png';
  Vector2 myPosition;
  Vector2 mySize = Vector2(50, 50);

  Gun(Vector2 position) : myPosition = position;


  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await Sprite.load(
      _sprite_gun,
      srcPosition: myPosition,
      srcSize: mySize,
      //images: super.images,
    );

    // Créer un SpriteComponent avec le sprite chargé
    SpriteComponent monSprite = SpriteComponent()
      ..sprite = await game.loadSprite(_sprite_gun)
      ..size = Vector2(50, 50) // Taille du sprite
      ..position = myPosition; // Position initiale

    add(monSprite);
  }
}