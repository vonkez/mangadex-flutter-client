import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:md_fclient/ui/home_controller.dart';
import 'package:md_fclient/ui/library.dart';
import 'package:md_fclient/ui/library_controller.dart';
import 'package:md_fclient/ui/login.dart';
import 'package:md_fclient/ui/manga_search_controller.dart';
import 'package:md_fclient/ui/manga_search_delegate.dart';
import 'package:md_fclient/ui/settings.dart';
import 'package:md_fclient/utils/auth.dart';
import 'package:md_fclient/utils/preloader.dart';

import 'ui/home.dart';
import 'ui/login_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(Preloader());
  Get.put(await Auth.init());
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(LibraryController());
  Get.put(MangaSearchController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget getHome() {
    if (Auth.to.loggedIn.value || Auth.to.guest.value) {
      print("HOMEPAGE");
      return MyHomePage(title: 'MangaDex',);
    }else {
      print("GO LOGIN");
      return const Login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MangaDex FClient',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        toggleableActiveColor: const Color.fromRGBO(255, 103, 64, 1),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(255, 103, 64, 1))),
        accentColor: const Color.fromRGBO(255, 103, 64, 1), // FAB color??
      ),
      themeMode: ThemeMode.dark,
      home: getHome(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController homeTabController;
  late TabController libraryTabController;

  @override
  void initState() {
    super.initState();
    homeTabController = TabController(length: 2, vsync: this);
    libraryTabController = TabController(length: 6, vsync: this);
  }

  void _changeIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset(
          "assets/md_logo.svg",
          fit: BoxFit.scaleDown,
        ),
        title: Text(widget.title),
        bottom: getTabBar(),
        actions: [
          IconButton(
          icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                query: MangaSearchController.to.query.value,
                delegate: MangaSearchDelegate(),
              );
            },
        ),],
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
      ),
      body: getSelectedContent(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Library'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active_rounded), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        elevation: 8,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(255, 103, 64, 1),
        onTap: _changeIndex,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return Home(tabController: homeTabController,);
      case 1:
        return Library(tabController: libraryTabController,);
      case 2:
        return Home(tabController: homeTabController,);
      case 3:
        return const Settings();
      default:
        return Home(tabController: homeTabController,);
    }
  }
  PreferredSizeWidget? getTabBar() {
    switch (_selectedIndex) {
      case 0:
        return TabBar(
          controller: homeTabController,
            tabs: const [
              Tab(
                text: 'Recently added',
              ),
              Tab(
                text: 'Recently updated',
              ),
            ]
        );
      case 1:
        return TabBar(
            isScrollable: true,
            controller: libraryTabController,
            tabs: const [
              Tab(
                text: 'Reading',
              ),
              Tab(
                text: 'On hold',
              ),
              Tab(
                text: 'Re reading',
              ),
              Tab(
                text: 'Plan to read',
              ),
              Tab(
                text: 'Completed',
              ),
              Tab(
                text: 'Dropped',
              ),
            ]
        );
      case 2:
        return null;
      case 3:
        return null;
      default:
        return null;
    }
  }
}
