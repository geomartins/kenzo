import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/preference_bloc.dart';

class PreferenceProvider extends InheritedWidget {
  final bloc = PreferenceBloc();

  PreferenceProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static PreferenceBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PreferenceProvider>()
        .bloc;
  }
}
