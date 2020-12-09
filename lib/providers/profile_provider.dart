import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/profile_bloc.dart';

class ProfileProvider extends InheritedWidget {
  final bloc = ProfileBloc();

  ProfileProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static ProfileBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProfileProvider>().bloc;
  }
}
