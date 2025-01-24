import 'package:coolorburn/cool_or_burn.dart';
import 'package:coolorburn/gen/assets.gen.dart';
import 'package:coolorburn/utils/sprite_animator_cache_service.dart';
import 'package:flame/src/components/sprite_component.dart';
import 'package:vector_math/vector_math_64.dart';

class LoadingCacheService extends SpriteCache{

  late SpriteComponent gameBackground;
  
  @override
  Future<SpriteComponent> getSpriteComponent({required String path, required Vector2 imgSize})async {
    Sprite sprite = await SpriteAnimatorCache.loadSprite(path);
    return SpriteComponent(sprite: sprite, size: imgSize);
  }

  @override
  Future<void> preloadSprites(CoolOrBurn gameRef) async{
        gameBackground = await getSpriteComponent(
        path: Assets.resources.images.gameBackground32x32.path,
        imgSize: gameRef.camDimension);}
}