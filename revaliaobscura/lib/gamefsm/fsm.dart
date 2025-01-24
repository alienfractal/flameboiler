import 'package:coolorburn/revalia_obs.dart';
import 'package:coolorburn/gamefsm/game_end.dart';
import 'package:coolorburn/gamefsm/game_loading.dart';
import 'package:coolorburn/gamefsm/game_menu.dart';
import 'package:coolorburn/gamefsm/game_score.dart';
import 'package:coolorburn/gamefsm/game_start.dart';
import 'package:coolorburn/gamefsm/istate.dart';

enum StateType {
  GameMenu,
  GameLoading,
  GameStart,
  GameEnd,
  GameScore
}

abstract class Fsm {
  late  StateType currentStateType = StateType.GameMenu;
  late IState currentState;
  String actions = "";
  final CoolOrBurn mainGame;
 

  static GameLoading gload = GameLoading();
  static GameStart gstart = GameStart();
  static GameMenu gmenu = GameMenu();
  static GameEnd gend = GameEnd();
  static GameScore gscore = GameScore();  

  Fsm({required this.currentState,required this.mainGame});

  void enter() {currentState.enter(this);}
  void update(double dt) {}
  void exit() {currentState.exit(this);}

  void gameStart();
  void gameMenu();
  void gameLoading();
  void gameEnd();
  void gameScore();

}
