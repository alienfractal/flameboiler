
import 'package:coolorburn/revalia_obs.dart';
import 'package:coolorburn/game/states/game/behaviours/actorflip_behavior.dart';
import 'package:coolorburn/game/states/game/model/actor_model.dart';
import 'package:coolorburn/game/states/game/handlers/cardview_animation_handler.dart';
import 'package:coolorburn/game/states/game/services/card_logic_service.dart';
import 'package:flame/components.dart';


import 'package:flame_behaviors/flame_behaviors.dart';


class ActorView extends PositionedEntity with HasGameRef<CoolOrBurn> {
  //late final SpriteComponent cardSprite;
 
  late ActorModel actorModel;
  int cardId = 0;
  static int actorCount = 0;
  late ActorAnimationHandler animationHandler;
  late CardLogicService gameCardLogicService;

  ActorView( {required this.actorModel, required super.position})
      : super(anchor: Anchor.center, size: Vector2.all(32), behaviors: [
          ActorBehavior(),
        ]) {
         
    // Initialize the card with default behaviors or properties
    // For example, you can add a visual component based on the card type
    // or add specific behaviors like flip, move, etc.
    actorCount++;
    cardId = actorCount;
    animationHandler = ActorAnimationHandler();
    gameCardLogicService = CardLogicService();
    if(actorModel.status == ActorModel.EMPTY_ENEMY){
      print("enemy card detected card.position ${position.x} ${position.y}"); 
    }else if(actorModel.status == ActorModel.RELIC){
      print("relic card detected card.position ${position.x} ${position.y}"); 
    } 
  }

  @override
  void onLoad() {
    super.onLoad();
    animationHandler.gameRef = gameRef;
    //print('cardModel.x  cardModel.y cardModel.value ${cardModel.x} ${cardModel.y} ${cardModel.value}');
    if (actorModel.status == ActorModel.DIRT) {
     
       animationHandler
            .loadAnimation(gameRef.cardCacheService.dirtAnimation,Vector2.all(32),this); 
      return;
    }
    print("cardModel.value ${actorModel.status}");
    animationHandler.loadAnimation(gameRef.cardCacheService.getAnimation(actorModel.status),Vector2.all(32),this);
  }

/// Updates the state of the card view.
  @override
  void update(double dt)  {
    
    if(animationHandler.isBombCardDone(this)){
         animationHandler
            .loadAnimation(gameRef.cardCacheService.rubbleAnimation,Vector2.all(32),this); 
    }

   
  }

  @override
  void onRemove() {
    super.onRemove();
    //print("CardView onRemove");
    animationHandler.cleanUpAnimations();
    removeFromParent();
  }

  
}
