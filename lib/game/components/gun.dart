
import 'package:first_app_flutter/game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Gun extends SpriteComponent with HasGameRef<SurvivalGame>, CollisionCallbacks {

  static const _sprite_gun = 'pistolet.png';

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Charger l'image en tant que sprite
    sprite = await game.loadSprite(_sprite_gun);

    // Créer un SpriteComponent avec le sprite chargé
    SpriteComponent monSprite = SpriteComponent()
      ..sprite = sprite
      ..size = Vector2(50, 50) // Taille du sprite
      ..position = Vector2(400, 400); // Position initiale

    // Ajouter le SpriteComponent au jeu
    add(monSprite);
  }
}