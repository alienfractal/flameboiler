// Example Behavior class for Card

 
import 'package:coolorburn/game/states/game/view/cardview.dart';
import 'package:coolorburn/cool_or_burn.dart';
import 'package:coolorburn/gen/assets.gen.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class ActorBehavior extends Behavior<ActorView>
    with TapCallbacks, HasGameRef<CoolOrBurn> {

  static int tapCount = 0;
  @override
  void update(double dt) {
    // Logic for the flip behavior
  }

  @override
  void onTapDown(TapDownEvent event)  {
    super.onTapDown(event);
    CoolOrBurn.logger.d("TAP DOWN");

    tapCount++;
    if (tapCount < 3) {
     

      gameRef.ap.playSoundFx(Assets.resources.audio.blipSelect1);
      //gameRef.ap.playSoundFx("flip.mp3");
    }else{
      tapCount = 0;
      gameRef.gboard.isEnemyDefeated = true;
    }
  }

 
}
