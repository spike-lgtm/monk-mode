import 'package:device_apps/device_apps.dart';
import 'package:monk_mode/main.dart';
import 'package:monk_mode/models/app.dart';
import 'package:monk_mode/services/db_service.dart';

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
        homeText: appData.last['header'],
        focus: appData.last['focus'] == 1,
        favAppSize: double.parse(appData.last['fav_app_size'].toString()),
        normalAppSize: double.parse(appData.last['normal_app_size'].toString()),
        favApps: favApps.map((e) => e!).toList(),
        allApps: allApps);
  }

  List<Application> getNonFavApps(
      List<Application> allApps, List<Application> favApps) {
    return allApps.where((element) => !favApps.contains(element)).toList();
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

  Future<bool> addFavApps(Application application) async {
    App app = App(
        id: 0, name: application.appName, packageName: application.packageName);
    final favAppDBService = DbService(dbName: DBHelper.favApps);
    int result = await favAppDBService.insert(app.toJson());
    if (result > 0) {
      return true;
    }
    return false;
  }

  Future<bool> removeAppFromFav(Application application) async {
    final favAppDBService = DbService(dbName: DBHelper.favApps);
    int result = await favAppDBService.deleteViaCustomRow(
        "package_name", application.packageName);
    if (result > 0) {
      return true;
    }
    return false;
  }

  Future<bool> updateFontSize(double favAppSize, double normalAppSize) async {
    final homeDbService = DbService(dbName: DBHelper.appContext);
    int update = await homeDbService.update({
      'id': 0,
      'normal_app_size': normalAppSize,
      'fav_app_size': favAppSize
    });
    return update > 0;
  }
}
