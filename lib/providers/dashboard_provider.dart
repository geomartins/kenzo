import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/dashboard_bloc.dart';

class DashboardProvider extends InheritedWidget {
  final bloc = DashboardBloc();

  DashboardProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static DashboardBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DashboardProvider>().bloc;
  }
}
