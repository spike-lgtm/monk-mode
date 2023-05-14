import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monk_mode/main.dart';
import 'package:monk_mode/services/app_services.dart';
import 'package:monk_mode/widgets/app_item.dart';

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
  final _formKey = GlobalKey<FormState>();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Focus Mode",
                    style: GoogleFonts.alegreya(
                        fontSize: 22, color: Colors.white70),
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
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.black,
                          title: Text(
                            "Change Font Size",
                            style: GoogleFonts.alegreya(
                                fontSize: 22, color: Colors.white70),
                          ),
                          content: SizedBox(
                            height: 120,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Text("Favourite App",
                                              style: GoogleFonts.alegreya(
                                                  fontSize: 14,
                                                  color: Colors.white70))),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          onSaved: (s) {
                                            widget.launcherAppContext
                                                .favAppSize = double.parse(s!);
                                          },
                                          style: GoogleFonts.alegreya(
                                              fontSize: 22,
                                              color: Colors.white70),
                                          initialValue: widget
                                              .launcherAppContext.favAppSize
                                              .toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Text("App List",
                                              style: GoogleFonts.alegreya(
                                                  fontSize: 14,
                                                  color: Colors.white70))),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          onSaved: (s) {
                                            widget.launcherAppContext
                                                    .normalAppSize =
                                                double.parse(s!);
                                          },
                                          style: GoogleFonts.alegreya(
                                              fontSize: 22,
                                              color: Colors.white70),
                                          initialValue: widget
                                              .launcherAppContext.normalAppSize
                                              .toString(),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Save"),
                              onPressed: () async {
                                _formKey.currentState!.save();
                                bool success = await widget.appServices
                                    .updateFontSize(
                                        widget.launcherAppContext.favAppSize,
                                        widget
                                            .launcherAppContext.normalAppSize);
                                if(!success) {
                                  const snackBar = SnackBar(
                                      content: Text(
                                          'Error: Could not change Font Size!'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Text(
                  "Change Font Size",
                  style:
                      GoogleFonts.alegreya(fontSize: 22, color: Colors.white70),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Favourite Apps",
                style:
                    GoogleFonts.alegreya(fontSize: 22, color: Colors.white70),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.white24,
              ),
              _buildAppListWidget(widget.launcherAppContext.favApps,
                  widget.launcherAppContext.favApps.isEmpty ? 50 : 150, true),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Other Apps",
                style:
                    GoogleFonts.alegreya(fontSize: 22, color: Colors.white70),
              ),
              const Divider(
                color: Colors.white24,
              ),
              _buildAppListWidget(
                  widget.appServices.getNonFavApps(
                      widget.launcherAppContext.allApps,
                      widget.launcherAppContext.favApps),
                  widget.launcherAppContext.favApps.isEmpty ? 450 : 350,
                  false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppListWidget(
      List<Application> apps, double height, bool isFav) {
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
                shrinkWrap: true,
                buildDefaultDragHandles: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: apps.map((app) {
                  return ReorderableDragStartListener(
                      key: Key(app.packageName),
                      enabled: false,
                      index: apps.indexOf(app),
                      child: AppItem(
                        fontSize: 18,
                        onAppPrefTap: () async {
                          bool processCompleted = false;
                          if (isFav) {
                            processCompleted =
                                await widget.appServices.removeAppFromFav(app);
                            if (processCompleted) {
                              setState(() {
                                widget.launcherAppContext.favApps.remove(app);
                              });
                            }
                          } else {
                            processCompleted =
                                await widget.appServices.addFavApps(app);
                            if (processCompleted) {
                              setState(() {
                                widget.launcherAppContext.favApps.add(app);
                              });
                            }
                          }

                          if (!processCompleted) {
                            const snackBar = SnackBar(
                                content: Text(
                                    'Error: Could not delete Favourite App'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
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
