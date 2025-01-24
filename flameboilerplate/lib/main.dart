import 'dart:convert';

import 'package:coolorburn/cool_or_burn.dart';
import 'package:coolorburn/gen/assets.gen.dart';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



Future<void> main() async {
  Flame.images.prefix = "";
  FlameAudio.audioCache.prefix = "";
  Flame.assets.prefix = "";
  WidgetsFlutterBinding.ensureInitialized();
  

  // Load translations for supported locales
  Map<String, dynamic> translations = await loadTranslations('resources/translations/');



  // Create the Flame game instance
  final CoolOrBurn cob = CoolOrBurn(translations: translations); // Pass the delegate to your game

  // Load translations
 
   GameWidget gameWidget = GameWidget(game: cob);
   
 

  
 
  //runApp(gameWidget);

    runApp(gameWidget);
  // Run the app with GameWidget.controlled
 
}

// Load translation files into a map
Future<Map<String, dynamic>> loadTranslations(String path) async {
  final Map<String, dynamic> allTranslations = {};

  // Add English translations
  String enJson = await rootBundle.loadString(Assets.resources.translations.en);
  allTranslations['en'] = jsonDecode(enJson);

  // Add Spanish translations (or any other locales)
  String esJson = await rootBundle.loadString(Assets.resources.translations.es);
  allTranslations['es'] = jsonDecode(esJson);

  return allTranslations;
}

