import 'package:device_apps/device_apps.dart';

class App {
  final int id;
  final String name;
  final String packageName;

  App({
    required this.id,
    required this.name,
    required this.packageName,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'package_name': packageName,
    };
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      id: json['id'],
      name: json['name'],
      packageName: json['package_name'],
    );
  }

  Future<Application?> getApplication() async {
    return await DeviceApps.getApp(packageName);
  }
}
