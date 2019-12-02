import 'package:image_picker/image_picker.dart';

import 'AppContextHolder.dart';

class ImageInput{
  AppContextHolder ctx;
  ImageInput(this.ctx);
  Future predictImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    AppContextHolder.appState.setState(() {
      ctx.state.busy = true;
    });
    ctx.models.predictImage(image);
  }
}