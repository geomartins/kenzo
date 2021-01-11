import 'package:flutter/material.dart';
import 'package:staff_portal/blocs/download_service_bloc.dart';

class DownloadServiceProvider extends InheritedWidget {
  final bloc = DownloadServiceBloc();

  DownloadServiceProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static DownloadServiceBloc of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DownloadServiceProvider>()
        .bloc;
  }
}
