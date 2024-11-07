import 'package:flame_audio/flame_audio.dart';

class AudioManager {

    // Création d'une instance singleton de la classe
    static final AudioManager _instance = AudioManager._internal();

    factory AudioManager() {
        return _instance;
    }

    AudioManager._internal();

    Future<void> preloadSounds() async {
        await FlameAudio.audioCache.loadAll(['zombie_cri.ogg', 'pan.ogg', 'explosed.ogg']);
    }

    void playZombieSound() {
        FlameAudio.play('zombie_cri.ogg', volume: 0.5);
    }

    void playPanSound() {
        FlameAudio.play('pan.ogg', volume: 0.5);
    }

    void playExplosedSound() {
        FlameAudio.play('explosed.ogg', volume: 0.5);
    }

}
