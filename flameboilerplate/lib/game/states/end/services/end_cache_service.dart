import 'package:coolorburn/cool_or_burn.dart';
import 'package:coolorburn/utils/sprite_animator_cache_service.dart';
import 'package:flame/src/components/sprite_component.dart';
import 'package:vector_math/vector_math_64.dart';

class EndCacheService extends SpriteCache {
  @override
  Future<SpriteComponent> getSpriteComponent({required String path, required Vector2 imgSize}) {
    // TODO: implement getSpriteComponent
    throw UnimplementedError();
  }

  @override
  Future<void> preloadSprites(CoolOrBurn gameRef) {
    // TODO: implement preloadSprites
    throw UnimplementedError();
  }
}