import 'package:flame/components.dart';
import 'package:flame/game.dart';

class ZombieSpritePreloader {

  final List<SpriteAnimation> _animations = [];
  static const _spriteMecha = 'mecha2.png';

  final Game game;

  ZombieSpritePreloader({required this.game});
  
  Future<void> preloadAnimations(int totalLines) async {
    for (int line = 0; line < totalLines; line++) {
      final animation = await _loadLineFromSprite(line);
      _animations.add(animation);
    }
  }

  SpriteAnimation? getAnimationForLine(int line) {
    if (line < 0 || line >= _animations.length) {
      print("error when load sprite with line : $line");
      return null; // Retourne null si la ligne demandée est invalide
    }
    return _animations[line];
  }

  /// Charge une ligne spécifique du sprite
  Future<SpriteAnimation> _loadLineFromSprite(int line) async {
    return await game.loadSpriteAnimation(
      _spriteMecha,
      SpriteAnimationData.sequenced(
        amount: 4, // Nombre de frames
        stepTime: 0.1, // Temps entre les frames
        textureSize: Vector2(65, 65),
        amountPerRow: 4,
        texturePosition: Vector2(0, line * 65),
        loop: false,
      ),
    );
  }

}