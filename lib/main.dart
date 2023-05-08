import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:minimal_launcher/launcher_ui/apps_screen.dart';
import 'package:minimal_launcher/launcher_ui/home_screen.dart';
import 'package:minimal_launcher/services/app_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: "minimal-launcher",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const LauncherPages(),
      ),
    );
  }
}

class LauncherPages extends StatefulWidget {
  const LauncherPages({super.key});
  @override
  State<LauncherPages> createState() => _LauncherPagesState();
}

class LauncherAppContext {
  String homeText;
  bool focus;
  List<Application> favApps;
  List<Application> allApps;

  LauncherAppContext(
      {this.homeText = "Write Something...",
      required this.focus,
      required this.favApps,
      required this.allApps});
}

class _LauncherPagesState extends State<LauncherPages> {
  AppServices appServices = AppServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040404),
      body: FutureBuilder<LauncherAppContext>(
        future: appServices.getAppContext(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: PageView(
                scrollDirection: Axis.horizontal,
                onPageChanged: (int pageIndex) {},
                children: [
                  HomeScreen(
                    launcherAppContext: snapshot.data!,
                    appServices: appServices,
                  ),
                  AppScreen(
                    appServices: appServices,
                    launcherAppContext: snapshot.data!,
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
