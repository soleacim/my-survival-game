import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/widgets.dart';
import 'package:first_app_flutter/game/game.dart';

class Background extends ParallaxComponent<SurvivalGame> {
  @override
  FutureOr<void> onLoad() async {

    final parallaxImages = await Future.wait([
      game.loadParallaxImage(
        'background.png',
        filterQuality: FilterQuality.none,
        repeat: ImageRepeat.repeat,
      ),
    ]);

    final layers = parallaxImages
        .map(
          (e) => ParallaxLayer(
            e,
            velocityMultiplier: Vector2(0, 4.0),
          ),
        )
        .toList();

    parallax = Parallax(layers, baseVelocity: null);

    size = game.size.clone();
  }
}
