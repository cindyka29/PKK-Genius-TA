import 'package:flutter/material.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/presentation/pages/splash_screen.dart';
import 'package:pkk/presentation/screens/anggota_screen.dart';
import 'package:pkk/presentation/screens/beranda_screen.dart';
import 'package:pkk/presentation/screens/jadwal_screen.dart';
import 'package:pkk/presentation/screens/kas_screen.dart';
import 'package:pkk/presentation/widgets/app_image_network.dart';
import 'package:pkk/provider/beranda_provider.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentPageIndex = 0;

  static const List<Widget> _screens = <Widget>[
    BerandaScreen(),
    AnggotaScreen(),
    JadwalScreen(),
    KasScreen(),
  ];

  void _visimisiDialog() {
    final themeContext = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(
                Icons.lightbulb_outlined,
                size: 125,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                ),
                decoration: BoxDecoration(
                  color: themeContext.primaryColorDark,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Visi-Misi',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Visi\nMelanjutkan untuk mewujudkan desa Kubutambahan yang "BALINS"\n\nMisi\n1. Menata aparatur pemerintahan desa Kubutambahan sehingga dapat melaksanakan tugas sesuai dengan tugas pokoknya masing-masing;\n2. Membina dan menciptakan kerukunan masyarakat desa Kubutambahan secara netral dan mandiri;',
            style: TextStyle(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _profileDialog() {
    final themeContext = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(
                Icons.person_outline,
                size: 125,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                decoration: BoxDecoration(
                  color: themeContext.primaryColorDark,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          content: const Text('helo'),
        );
      },
    );
  }

  void _dokumentasiDialog() {
    final themeContext = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(
                Icons.person_outline,
                size: 125,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                decoration: BoxDecoration(
                  color: themeContext.primaryColorDark,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Dokumentasi Kegiatan',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          content: const Text('helo'),
        );
      },
    );
  }

  void _logoutDialog() {
    final themeContext = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Icon(
                Icons.logout_outlined,
                size: 125,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                ),
                decoration: BoxDecoration(
                  color: themeContext.primaryColorDark,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin untuk keluar?',
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color(0xFF9CD0D7),
                ),
              ),
              child: const Text('Tidak'),
            ),
            FilledButton(
              onPressed: () {
                Provider.of<BerandaProvider>(context, listen: false)
                    .logout()
                    .then((isSuccess) {
                  Navigator.of(context).pop();
                  // if (!isSuccess) {
                  //   Fluttertoast.showToast(msg: 'Gagal logout');
                  //   return;
                  // }
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const SplashScreen(),
                    ),
                  );
                });
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    final itemsNavbar = <Widget>[
      const NavigationDestination(
        icon: Icon(
          Icons.home_outlined,
          color: Colors.black,
        ),
        label: 'Beranda',
      ),
      const NavigationDestination(
        icon: Icon(
          Icons.person_outlined,
          color: Colors.black,
        ),
        label: 'Anggota',
      ),
      const NavigationDestination(
        icon: Icon(
          Icons.event_outlined,
          color: Colors.black,
        ),
        label: 'Jadwal',
      ),
      const NavigationDestination(
        icon: Icon(
          Icons.account_balance_wallet_outlined,
          color: Colors.black,
        ),
        label: 'Kas',
      ),
    ];

    final userData = Preferences.getUser();
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 200,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: SizedBox.fromSize(
                            size: const Size.fromRadius(56), // Image radius
                            child: AppImageNetwork(
                              userData?.image ?? "assets/images/pkk-logo.png",
                              fit: BoxFit.cover,
                            )),
                      ),
                      Text(
                        userData?.name ?? '-',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ), // Name profile
                      Text(
                        userData?.name ?? '-',
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ) // Telephone Number
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb_outlined),
                title: const Text('Visi-Misi'),
                onTap: _visimisiDialog,
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: const Text('Profile'),
                onTap: _profileDialog,
              ),
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: const Text('Dokumentasi Kegiatan'),
                onTap: _dokumentasiDialog,
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Logout'),
                onTap: _logoutDialog,
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _currentPageIndex,
          children: _screens,
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          indicatorColor: themeContext.primaryColor,
          selectedIndex: _currentPageIndex,
          destinations: itemsNavbar,
        ),
      ),
    );
  }
}
