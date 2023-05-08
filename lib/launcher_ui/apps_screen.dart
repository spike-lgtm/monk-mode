import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:monk_mode/launcher_ui/settings_screen.dart';
import 'package:monk_mode/main.dart';
import 'package:monk_mode/services/app_services.dart';
import 'package:monk_mode/widgets/app_item.dart';

class AppScreen extends StatefulWidget {
  final LauncherAppContext launcherAppContext;
  final AppServices appServices;
  const AppScreen(
      {Key? key, required this.launcherAppContext, required this.appServices})
      : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: ReorderableListView(
                  buildDefaultDragHandles: true,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  children: widget.launcherAppContext.allApps.map((app) {
                    return ReorderableDragStartListener(
                        key: Key(app.packageName),
                        enabled: false,
                        index: widget.launcherAppContext.allApps.indexOf(app),
                        child: AppItem(
                          focus: widget.launcherAppContext.focus,
                          application: app,
                        ));
                  }).toList(),
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final Application item =
                          widget.launcherAppContext.allApps.removeAt(oldIndex);
                      widget.launcherAppContext.allApps.insert(newIndex, item);
                    });
                  },
                ),
              ),
              Expanded(
                  flex: 1,
                  child: IconButton(
                      padding: const EdgeInsets.only(right: 25),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingScreen(
                                    appServices: widget.appServices,
                                    launcherAppContext:
                                        widget.launcherAppContext,
                                  )),
                        );
                      },
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: Colors.white54,
                      ))),
            ],
          ),
        ),
      ],
    );
  }
}
