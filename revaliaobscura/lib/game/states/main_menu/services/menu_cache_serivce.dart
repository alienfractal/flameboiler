import 'package:coolorburn/revalia_obs.dart';
import 'package:coolorburn/gen/assets.gen.dart';
import 'package:coolorburn/utils/sprite_animator_cache_service.dart';
import 'package:coolorburn/utils/image_utils.dart';
import 'package:flame/components.dart';
import 'package:flame/src/components/sprite_component.dart';
import 'package:flame/src/sprite_animation.dart';

class MenuCacheSerivce extends SpriteCache {
  late SpriteComponent gameBackground;
  late SpriteComponent gameTitle;
  late SpriteComponent gameSubTitle;
  late SpriteComponent companyTitle;



  @override
  Future<void> preloadSprites(CoolOrBurn gameRef) async {
companyTitle =  await getSpriteComponent(
        path: Assets.resources.images.gamelogo140x32.path,
        imgSize: Vector2(140, 32));
    
    
       gameBackground = await getSpriteComponent(
        path: Assets.resources.images.gameBackground32x32.path,
        imgSize: gameRef.camDimension);
      
    // Game Tiele sprite
    gameTitle = await getSpriteComponent(
        path: Assets.resources.images.gameTitle.path,
        imgSize: Vector2(160, 90));

    gameTitle.position = ComponentUtils.centerComponent(
        gameRef.camDimension, gameTitle,
        offsetX: 2, offsetY: -1);

    gameSubTitle = await getSpriteComponent(
        path: Assets.resources.images.gamesubTitle.path,
        imgSize: Vector2(140, 32));
        
    gameSubTitle.position = ComponentUtils.centerComponent(
        gameRef.camDimension, gameSubTitle,
        offsetX: 2, offsetY: 3.5);
  }
  
  @override
  Future<SpriteComponent> getSpriteComponent({required String path, required Vector2 imgSize})async {
    Sprite sprite = await SpriteAnimatorCache.loadSprite(path);
    return SpriteComponent(sprite: sprite, size: imgSize);
  }

}
