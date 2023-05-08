import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_launcher/main.dart';
import 'package:minimal_launcher/services/app_services.dart';
import 'package:minimal_launcher/widgets/app_item.dart';

class SettingScreen extends StatefulWidget {
  final AppServices appServices;
  final LauncherAppContext launcherAppContext;

  const SettingScreen(
      {Key? key, required this.appServices, required this.launcherAppContext})
      : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool _isSwitched;

  @override
  void initState() {
    _isSwitched = widget.launcherAppContext.focus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white70,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LauncherPages()),
            );
          },
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.alegreya(color: Colors.white70),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Focus Mode",
                  style:
                      GoogleFonts.alegreya(fontSize: 22, color: Colors.white70),
                ),
                Switch(
                  value: _isSwitched,
                  onChanged: (bool value) async {
                    _isSwitched =
                        await widget.appServices.updateFocusMode(value);
                    setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Favourite Apps",
              style: GoogleFonts.alegreya(fontSize: 22, color: Colors.white70),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.white24,
            ),
            _buildAppListWidget(widget.launcherAppContext.favApps, widget.launcherAppContext.favApps.isEmpty ? 50 : 150, true),
            const SizedBox(
              height: 25,
            ),
            Text(
              "Other Apps",
              style: GoogleFonts.alegreya(fontSize: 22, color: Colors.white70),
            ),
            const Divider(
              color: Colors.white24,
            ),
            Expanded(
                child: _buildAppListWidget(
                    widget.appServices.getNonFavApps(
                        widget.launcherAppContext.allApps,
                        widget.launcherAppContext.favApps),
                    widget.launcherAppContext.favApps.isEmpty ? 450 : 350, false)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppListWidget(List<Application> apps, double height, bool isFav) {
    return SingleChildScrollView(
      child: SizedBox(
        height: height,
        child: apps.isEmpty
            ? Text(
                "There are no apps listed in this section",
                style:
                    GoogleFonts.alegreya(fontSize: 14, color: Colors.white70),
              )
            : ReorderableListView(
                buildDefaultDragHandles: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: apps.map((app) {
                  return ReorderableDragStartListener(
                      key: Key(app.packageName),
                      enabled: false,
                      index: apps.indexOf(app),
                      child: AppItem(
                        isFav: isFav,
                        application: app,
                      ));
                }).toList(),
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final Application item = apps.removeAt(oldIndex);
                    apps.insert(newIndex, item);
                  });
                },
              ),
      ),
    );
  }
}
