import 'ImageInput.dart';
import 'SharedStates.dart';
import 'UiRenders.dart';
import 'main.dart';
import 'models.dart';

class AppContextHolder{
  static MyAppState appState;
  SharedStates state = new SharedStates();
  Models models;
  ImageInput imgInput;
  UiRenders renders;
  AppContextHolder(){
    imgInput = new ImageInput(this);
    renders = new UiRenders(this);
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