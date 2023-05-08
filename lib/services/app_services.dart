import 'package:device_apps/device_apps.dart';
import 'package:minimal_launcher/launcher_ui/settings_screen.dart';
import 'package:minimal_launcher/main.dart';
import 'package:minimal_launcher/models/app.dart';
import 'package:minimal_launcher/models/todo.dart';
import 'package:minimal_launcher/services/db_service.dart';

class AppServices {
  Future<List<Application>> getDeviceApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );
    apps.sort((a, b) => a.appName.compareTo(b.appName));
    apps.removeWhere((app) => app.appName == "minimal_launcher");
    return apps;
  }

  Future<LauncherAppContext> getAppContext() async {
    final favAppDBService = DbService(dbName: DBHelper.favApps);
    final appContextDbService = DbService(dbName: DBHelper.appContext);

    List<Map<String, dynamic>> appData =
        await appContextDbService.queryAllRows();
    List<Map<String, dynamic>> favAppsJson =
        await favAppDBService.queryAllRows();
    List<Application> allApps = await getDeviceApps();
    List<Application?> favApps = await Future.wait(favAppsJson
        .map((e) => App.fromJson(e))
        .toList()
        .map((e) => e.getApplication()));
    return LauncherAppContext(
        homeText: appData[0]['header'],
        focus: appData[0]['focus'] == 1,
        favApps: favApps.map((e) => e!).toList(),
        allApps: allApps);
  }

  List<Application> getNonFavApps(
      List<Application> allApps, List<Application> favApps) {
    return allApps.where((element) => !favApps.contains(element)).toList();
  }

  Future<List<TodoItem>> getAllTodoItems() async {
    final dbService = DbService(dbName: DBHelper.todoList);
    List<Map<String, dynamic>> todoItemsJson = await dbService.queryAllRows();
    return todoItemsJson.map((e) => TodoItem.fromJson(e)).toList();
  }

  Future<String> updateHomeHeader(String header) async {
    final homeDbService = DbService(dbName: DBHelper.appContext);
    int update = await homeDbService.update({'id': 0, 'header': header});
    if (update > 0) {
      return header;
    }
    return "Database update failed, Please try again!";
  }

  Future<bool> updateFocusMode(bool focus) async {
    final homeDbService = DbService(dbName: DBHelper.appContext);
    int update = await homeDbService.update({'id': 0, 'focus': focus ? 1 : 0});
    if (update > 0) {
      return focus;
    }
    return !focus;
  }
}
