// Abstract class to act as an interface for game states
import 'package:coolorburn/gamefsm/fsm.dart';

abstract class IState {
  void enter(Fsm gameFsm);
  void update(double dt);
  void exit(Fsm gameFsm);
}