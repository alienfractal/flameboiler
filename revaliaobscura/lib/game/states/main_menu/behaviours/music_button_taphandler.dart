
import 'package:coolorburn/revalia_obs.dart';
import 'package:coolorburn/utils/game_button.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_behaviors/flame_behaviors.dart';

class MusicButtonTapHandler extends Behavior<GameButton>  with TapCallbacks, HasGameRef<CoolOrBurn>{

  @override
  void onTapDown(TapDownEvent event) {
 
        Future.delayed(const Duration(milliseconds: 100), () {
          
            parent.currentFrameIndex+=1;  
            int frameIndex = parent.currentFrameIndex%parent.spriteSheet.columns;
            parent.setFrame(frameIndex);
          
            //gameRef.ap.updateMusicVolume(frameIndex);
          
            
         
        });
    
    super.onTapDown(event);
  }

}