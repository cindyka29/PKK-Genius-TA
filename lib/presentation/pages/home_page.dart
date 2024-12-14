import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/data/res/activities_response.dart';
import 'package:pkk/presentation/pages/change_password_page.dart';
import 'package:pkk/presentation/pages/splash_screen.dart';
import 'package:pkk/presentation/screens/absensi_screen.dart';
import 'package:pkk/presentation/screens/anggota_screen.dart';
import 'package:pkk/presentation/screens/beranda_screen.dart';
import 'package:pkk/presentation/screens/iuran_screen.dart';
import 'package:pkk/presentation/screens/jadwal_screen.dart';
import 'package:pkk/presentation/screens/kas_screen.dart';
import 'package:pkk/presentation/screens/tambah_anggota_screen.dart';
import 'package:pkk/presentation/widgets/app_image_network.dart';
import 'package:pkk/provider/beranda_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;

  static const List<Widget> _adminScreens = <Widget>[
    BerandaScreen(),
    AnggotaScreen(),
    TambahAnggotaScreen(),
    JadwalScreen(),
    KasScreen(),
  ];

  static const List<Widget> _userScreens = <Widget>[
    BerandaScreen(),
    AnggotaScreen(),
    AbsensiScreen(),
    IuranScreen(),
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
          title: Wrap(
            runSpacing: 12,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(56), // Image radius
                  child: AppImageNetwork(
                    Preferences.getUser()?.image ??
                        "assets/images/pkk-logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
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
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
          content: Wrap(
            runSpacing: 8,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              Text(
                Preferences.getUser()?.name ?? '-',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ), // Name profile
              Text(
                Preferences.getUser()?.phone ?? '-',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                Preferences.getUser()?.jabatan ?? '-',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ) // Telephone Number
            ],
          ),
        );
      },
    );
  }

  // void _changePassword() {
  //   final themeContext = Theme.of(context);
  //   showDialog(
  //     context: context,
  //     builder: (context) {

  //     },
  //   );
  // }

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
                  if (!isSuccess) {
                    Fluttertoast.showToast(msg: 'Gagal logout');
                    return;
                  }
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
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);
    final userData = Preferences.getUser();

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
          Icons.people,
          color: Colors.black,
        ),
        label: 'Anggota',
      ),
      if (userData?.role == 'admin')
        const NavigationDestination(
          icon: Icon(
            Icons.add_outlined,
            color: Colors.black,
          ),
          label: 'Tambah',
        ),
      if (userData?.role == 'admin')
        const NavigationDestination(
          icon: Icon(
            Icons.event_outlined,
            color: Colors.black,
          ),
          label: 'Jadwal',
        ),
      if (userData?.role != 'admin')
        const NavigationDestination(
          icon: Badge(
            child: Icon(
              Icons.person_4_outlined,
              color: Colors.black,
            ),
          ),
          label: 'Absensi',
        ),
      if (userData?.role != 'admin')
        const NavigationDestination(
          icon: Badge(
            child: Icon(
              Icons.paid_outlined,
              color: Colors.black,
            ),
          ),
          label: 'Iuran',
        ),
      const NavigationDestination(
        icon: Icon(
          Icons.account_balance_wallet_outlined,
          color: Colors.black,
        ),
        label: 'Kas',
      ),
    ];

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
                          ),
                        ),
                      ),
                      Text(
                        userData?.name ?? '-',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ), // Name profile
                      Text(
                        userData?.phone ?? '-',
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
                leading: const Icon(Icons.vpn_key),
                title: const Text('Ubah Sandi'),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage())),
              ),
              if (userData?.role == 'admin')
                ListTile(
                  leading: const Icon(Icons.folder_outlined),
                  title: const Text('Dokumentasi Kegiatan'),
                  onTap: () {
                    final provider =
                        Provider.of<BerandaProvider>(context, listen: false);
                    DocumentationForm.show(
                      context: context,
                      activityList: provider.listActivity,
                      onSubmit: (data) async {
                        return await provider.addDocumentation(data);
                      },
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Logout'),
                onTap: _logoutDialog,
              ),
            ],
          ),
        ),
        body: userData?.role == 'admin'
            ? IndexedStack(
                index: _currentPageIndex,
                children: _adminScreens,
              )
            : IndexedStack(
                index: _currentPageIndex,
                children: _userScreens,
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

class DocumentationForm extends StatefulWidget {
  const DocumentationForm(
      {super.key, required this.activityList, required this.onSubmit});

  final List<Activity> activityList;
  final void Function(Activity) onSubmit;

  static Future<void> show(
      {required BuildContext context,
      required List<Activity> activityList,
      required Future<bool> Function(Activity) onSubmit}) async {
    final themeContext = Theme.of(context);
    await showDialog(
        context: context,
        builder: (context) {
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
            content: DocumentationForm(
              activityList: activityList,
              onSubmit: (data) {
                onSubmit(data).then((isSuccess) {
                  if (isSuccess) {
                    Navigator.of(context).pop();
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Unggah dokumentasi kegiatan gagal');
                  }
                });
              },
            ),
          );
        });
  }

  @override
  State<DocumentationForm> createState() => _DocumentationFormState();
}

class _DocumentationFormState extends State<DocumentationForm> {
  late final GlobalKey<FormBuilderState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          // runSpacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderDropdown<String>(
              name: 'kegiatan',
              decoration: const InputDecoration(
                hintText: 'Kegiatan',
              ),
              items: widget.activityList
                  .map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name ?? '-'),
                      ))
                  .toList(),
              validator: FormBuilderValidators.required(),
            ),
            FormBuilderTextField(
              name: 'nama',
              decoration: const InputDecoration(hintText: 'Nama'),
              validator: FormBuilderValidators.required(),
            ),
            FormBuilderDateTimePicker(
              name: 'tanggal',
              decoration: const InputDecoration(hintText: 'Tanggal'),
              inputType: InputType.date,
              validator: FormBuilderValidators.required(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: FormBuilderFilePicker(
                name: 'gambar',
                maxFiles: 1,
                decoration: const InputDecoration(labelText: 'Gambar'),
                validator: FormBuilderValidators.required(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final isValid =
                    formKey.currentState?.saveAndValidate() ?? false;
                if (!isValid) return;
                widget.onSubmit(submittedData);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Activity get submittedData {
    final values = formKey.currentState!.instantValue;
    return Activity(
      id: values['kegiatan'],
      name: values['nama'],
      date: values['tanggal'],
      localDocumentation: File(values['gambar']?.first.path!),
    );
  }
}
