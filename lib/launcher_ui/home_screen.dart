import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_launcher/main.dart';
import 'package:minimal_launcher/services/app_services.dart';
import 'package:minimal_launcher/widgets/app_item.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final LauncherAppContext launcherAppContext;
  final AppServices appServices;
  const HomeScreen(
      {Key? key, required this.launcherAppContext, required this.appServices})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String currentValue;
  bool isWrite = false;

  @override
  void initState() {
    currentValue = widget.launcherAppContext.homeText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 80),
          Container(
            color: Colors.white10,
            width: 150,
            child: DigitalClock(
              is24HourTimeFormat: false,
              amPmDigitTextStyle:
                  GoogleFonts.alegreya(fontSize: 14, color: Colors.white70),
              hourMinuteDigitTextStyle:
                  GoogleFonts.alegreya(fontSize: 28, color: Colors.white70),
              colon: Text(
                ":",
                style:
                    GoogleFonts.alegreya(fontSize: 18, color: Colors.white70),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            DateFormat('EEEE | MMMM dd, y').format(DateTime.now()),
            style: GoogleFonts.alegreya(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 5),
          Text(
              "${DateTime(DateTime.now().year, 12, 31).difference(DateTime.now()).inDays} days left this year!",
              style: GoogleFonts.alegreya(fontSize: 14, color: Colors.white70)),
          SizedBox(height: 5),
          Divider(
            color: Colors.white70,
            thickness: 0.5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: SizedBox(
                    height: 120,
                    child: TextFormField(
                        initialValue: widget.launcherAppContext.homeText,
                        onTapOutside: (_) {
                          updateSaveState();
                        },
                        onChanged: (String text) {
                          updateSaveState();
                          widget.launcherAppContext.homeText = text;
                        },
                        decoration: InputDecoration(
                          hintText: "Write Something...",
                          hintStyle: GoogleFonts.alegreya(
                              fontSize: 26, color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        maxLines: 5,
                        style: GoogleFonts.alegreya(
                            fontSize: 26, color: Colors.white70))),
              ),
            ],
          ),
          if (isWrite)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    "Save",
                    style: GoogleFonts.alegreya(
                        fontSize: 14, color: Colors.white70),
                  ),
                  onPressed: () async {
                    currentValue = await widget.appServices
                        .updateHomeHeader(widget.launcherAppContext.homeText);
                    updateSaveState();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                )
              ],
            ),
          Divider(color: Colors.white70, thickness: 0.1),
          SizedBox(height: 80),
          Expanded(
            child: ReorderableListView(
              buildDefaultDragHandles: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: widget.launcherAppContext.favApps.map((app) {
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
                      widget.launcherAppContext.favApps.removeAt(oldIndex);
                  widget.launcherAppContext.favApps.insert(newIndex, item);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  updateSaveState() {
    setState(() {
      if (widget.launcherAppContext.homeText != currentValue) {
        isWrite = true;
      } else {
        isWrite = false;
      }
    });
  }
}
