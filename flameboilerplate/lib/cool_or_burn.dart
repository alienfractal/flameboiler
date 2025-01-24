import 'dart:async';
import 'dart:ui' as ui;
import 'dart:ui';


import 'package:coolorburn/game/states/game/services/actor_cache_service.dart';
import 'package:coolorburn/game/states/game/view/gameboard_view.dart';
import 'package:coolorburn/game/states/end/views/end_screenview.dart';
import 'package:coolorburn/game/states/loading/services/loading_cache_service.dart';
import 'package:coolorburn/game/states/loading/views/loading_screenview.dart';
import 'package:coolorburn/game/states/main_menu/services/menu_cache_serivce.dart';
import 'package:coolorburn/game/states/main_menu/views/main_menuview.dart';
import 'package:coolorburn/game/states/score/view/score_screenview.dart';
import 'package:coolorburn/gamefsm/fsm.dart';
import 'package:coolorburn/gamefsm/game_fsm.dart';
import 'package:coolorburn/gen/assets.gen.dart';
import 'package:coolorburn/utils/web_audio_player.dart';


import 'package:flame/camera.dart';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
 

 

abstract class ViewTransitionInterface {
  void transitionToNextState();
}

class CoolOrBurn extends FlameGame {
  ui.FragmentShader? shader;
  ui.Image? texture;
  late final CameraComponent cam;
  late WebAudioPlayer ap;
  late GameFsm gameFsm;
  final GameboardView gboard = GameboardView();
  final MainMenuView menuView = MainMenuView();
  final LoadingView loadingView = LoadingView();
  final GameEndView endView = GameEndView();
  final GameScoreView scoreView = GameScoreView();
  static final Logger logger = Logger();
  Vector2 camDimension = Vector2(320, 200);
  late FixedResolutionViewport viewport;
  late bool isCrtShaderActive;
  late ui.FragmentProgram uiProgram;


  late CardCacheService cardCacheService;
  late MenuCacheSerivce menuCacheService;
  late LoadingCacheService loadingCacheService;
  
 
  late GameWidget gameWidget;
  
  Map<String, dynamic> translations;
  String currentLocale = 'en'; // Default to English


  CoolOrBurn({required this.translations} ) {
     ap = WebAudioPlayer();
     isCrtShaderActive = false;
     

     cardCacheService = CardCacheService();
     menuCacheService = MenuCacheSerivce();
     loadingCacheService = LoadingCacheService();
     
     
  }


   // Helper to fetch translations
  String translate(String key) {
    try {
      final keys = key.split('.');
      dynamic value = translations[currentLocale];
      for (final k in keys) {
        value = value[k];
        if (value == null) break;
      }
      return value ?? key; // Return key if translation is missing
    } catch (e) {
      return key; // Return key on any error
    }
  }
  @override
  void onAttach() {
    // TODO: implement onAttach
    super.onAttach();
   
  
  }

  @override
  void onDispose() {
    CoolOrBurn.logger.d("CoolOrBurn: onDispose");
    super.onDispose();
  }

  @override
  void onMount() {
    super.onMount();
    CoolOrBurn.logger.d("CoolOrBurn: onMount");
    print(" Translate : ${translate('game.start_message')}");
 
    //EasyLocalization.of(gameWidget.context!)!.locale = Locale('en', 'US');
    
   
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    CoolOrBurn.logger.d("Screen resized to: $size");
  }

  @override
  void render(Canvas canvas) {
    // Render all components first to the game canvas
    super.render(canvas);
    if (!isCrtShaderActive) {
      return;
    }
    // Capture the game texture after rendering components
    print("rendering shader captureGameTexture()");
    texture = captureGameTexture();

    // Apply the shader using the CustomPainter
    if (shader != null && texture != null) {
      final shaderPainter = ShaderPainter(shader: shader, texture: texture);
      final pictureRecorder = ui.PictureRecorder();
      final canvasForPainter = Canvas(pictureRecorder);

      // Use the painter to draw on the canvas
      shaderPainter.paint(canvasForPainter, size.toSize());

      // Convert to an image and draw on the main canvas
      final picture = pictureRecorder.endRecording();
      final uiImage = picture.toImageSync(size.x.toInt(), size.y.toInt());

      // Draw the final result on the main canvas
      canvas.drawImage(uiImage, Offset.zero, Paint());
    }
  }

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    CoolOrBurn.logger.d("CoolOrBurn: onLoad");
    // Load the shader
    uiProgram =
    await ui.FragmentProgram.fromAsset('resources/shaders/test.frag');
    await cardCacheService.preloadAnimations(this);
    await menuCacheService.preloadSprites(this);
    await loadingCacheService.preloadSprites(this);
    await ap.initSfxPool(Assets.resources.audio.values);
    //await FlutterI18n.ensureInitialized();
    
    

    if (isCrtShaderActive) {
      shader = uiProgram.fragmentShader();
      texture = captureGameTexture();
    }

    PackageInfo.fromPlatform().then((packageInfo) async {
      CoolOrBurn.logger.d(packageInfo.toString());
      menuView.gameVersion = packageInfo.version;
      gameFsm = GameFsm(currentState: Fsm.gmenu, mainGame: this);

      viewport = FixedResolutionViewport(resolution: camDimension);
      cam = CameraComponent.withFixedResolution(
          world: menuView, width: camDimension.x, height: camDimension.y);

      cam.viewport = viewport;
      cam.viewfinder.anchor = Anchor.topLeft;
      // cam.viewfinder.position = size / 4;
      cam.viewfinder.zoom = 1.0;

      addAll([cam, menuView]);
    });
  }

  ui.Image captureGameTexture() {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    super.render(canvas);
    final picture = recorder.endRecording();
    return picture.toImageSync(size.x.toInt(), size.y.toInt());
  }

  // Method to switch worlds
  void switchToWorld(World newWorld) {
    /*cam.world = gboard; // Switch the camera to focus on the new world
    cam.viewfinder.anchor = Anchor.topLeft;
    add(gboard);*/
    if (newWorld.runtimeType == GameboardView) {
      cam.world = gboard;
    } else if (newWorld.runtimeType == MainMenuView) {
      cam.world = menuView;
    } else if (newWorld.runtimeType == LoadingView) {
      cam.world = loadingView;
    } else if (newWorld.runtimeType == GameEndView) {
      cam.world = endView;
    } else if (newWorld.runtimeType == GameScoreView) {
      cam.world = scoreView;
    }

    cam.viewfinder.anchor = Anchor.topLeft;
    add(newWorld);
  }

  void clearWorld(StateType nextStateType) {
    //print(gameFsm.currentState.toString());
    CoolOrBurn.logger.d(gameFsm.currentState.toString());
    switch (nextStateType) {
      case StateType.GameMenu:
        remove(menuView);
        break;
      case StateType.GameLoading:
        remove(loadingView);
        break;
      case StateType.GameStart:
        remove(gboard);
        break;
      case StateType.GameEnd:
        remove(endView);
        break;
      case StateType.GameScore:
        remove(scoreView);
        break;
      default:
        break;
    }
  }
}

//Shader call
class ShaderPainter extends CustomPainter {
  final ui.FragmentShader? shader;
  final ui.Image? texture;

  ShaderPainter({this.shader, this.texture});

  @override
  void paint(Canvas canvas, Size size) {
    if (shader != null && texture != null) {
      shader!.setFloat(0, texture!.width.toDouble()); // uResolution.x
      shader!.setFloat(1, texture!.height.toDouble()); // uResolution.y
      shader!.setImageSampler(0, texture!); // uTexture

      final paint = Paint()..shader = shader;

      // Apply shader effect to entire canvas
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint every frame, since texture and shader may change
  }
}
