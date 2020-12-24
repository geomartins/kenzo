class FcmConfigureModel {
  final dynamic viewId;
  final dynamic arguments;

  FcmConfigureModel.fromMap(Map<dynamic, dynamic> data)
      : viewId = data['view_id'],
        arguments = data['arguments'];
}
