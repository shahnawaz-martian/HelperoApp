class ConfigModel {
  bool? hasLocaldb;

  ConfigModel({this.hasLocaldb});

  ConfigModel.fromJson(Map<String, dynamic> json) {
    hasLocaldb = json['has_local_db'];
  }

  Map<String, dynamic> toJson() {
    return {
      'has_local_db': hasLocaldb,
    };
  }
}
