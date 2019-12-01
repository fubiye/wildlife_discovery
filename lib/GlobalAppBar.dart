import 'package:flutter/material.dart';

import 'SharedStates.dart';
import 'main.dart';

class GlobalAppBar extends AppBar{
  static State _state;
  static Text _title = Text('博物菌');
  static ImageIcon _leading = ImageIcon(AssetImage('assets/leading-s.png'));
  static SharedStates sharedStates;
  static onSelect(model) async {
    _state.setState((){
      sharedStates.busy = true;
    });
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
    State state,
    SharedStates sharedStates
  }): super(
    title: _title,
    leading: _leading,
    actions: _actions
  ){
    GlobalAppBar._state = state;
    GlobalAppBar.sharedStates = sharedStates;
  }
}