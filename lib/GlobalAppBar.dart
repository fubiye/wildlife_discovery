import 'package:flutter/material.dart';

import 'AppContextHolder.dart';
import 'consts.dart';

class GlobalAppBar extends AppBar{

  static AppContextHolder ctx;
  static Text _title = Text(APP_TITLE);
  static ImageIcon _leading = ImageIcon(AssetImage(APP_LEADING_IMG));
  static onSelect(model) async {
    AppContextHolder.appState.setState(() {
      ctx.state.busy = true;
      ctx.state.model = model;
      ctx.state.recognitions = null;
    });
    await ctx.models.loadModel();

    if (ctx.state.image != null){
      ctx.models.predictImage(ctx.state.image);
    }else{
      AppContextHolder.appState.setState(() {
        ctx.state.busy = false;
      });
    }
  }
  static List<Widget> _actions = [
    PopupMenuButton<String>(
    onSelected: onSelect,
    itemBuilder: (context) {
      List<PopupMenuEntry<String>> menuEntries = [
        const PopupMenuItem<String>(
          child: Text(ssd),
          value: ssd,
        ),
        const PopupMenuItem<String>(
          child: Text(yolo),
          value: yolo,
        )
      ];
      return menuEntries;
    },
  )];

  GlobalAppBar({
    AppContextHolder ctx
  }): super(
    title: _title,
    leading: _leading,
    actions: _actions
  ){
    GlobalAppBar.ctx = ctx;
  }
}