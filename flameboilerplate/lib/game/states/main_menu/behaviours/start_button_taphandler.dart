
import 'package:coolorburn/cool_or_burn.dart';
import 'package:coolorburn/utils/game_button.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class StartButtonTapHandler extends Behavior<GameButton>  with TapCallbacks, HasGameRef<CoolOrBurn>{

  @override
  void onTapDown(TapDownEvent event) {
   
    print('StartButton tapped');
 
        parent.size *= 0.99;  // Enlarge the button by 10%
        parent.spriteComponent.size *= 0.99;  // Also enlarge the sprite

        // Reset the size after some delay
        Future.delayed(const Duration(milliseconds: 100), () {
            parent.size /= 0.99;  // Reset to original size
            parent.spriteComponent.size /= 0.99;  // Reset sprite size
            gameRef.ap.stopMusic(); 
            gameRef.menuView.emplasedTime = -1;
            gameRef.gameFsm.gameLoading();
        });
    
    super.onTapDown(event);
  }

}