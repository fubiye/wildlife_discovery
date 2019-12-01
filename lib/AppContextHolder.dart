import 'SharedStates.dart';
import 'main.dart';
import 'models.dart';

class AppContextHolder{
  static MyAppState appState;
  SharedStates state = new SharedStates();
  Models models;
  AppContextHolder(){
    models = new Models(this);
    state.busy = true;
    models.loadModel().then((val) {
      if(appState == null){
        return;
      }
      appState.setState(() {
        state.busy = false;
      });
    });
  }
}