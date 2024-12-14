import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pkk/presentation/pages/splash_screen.dart';
import 'package:pkk/provider/change_password_provider.dart';
import 'package:pkk/provider/kegiatan_absensi_provider.dart';
import 'package:pkk/provider/anggota_provider.dart';
import 'package:pkk/provider/beranda_provider.dart';
import 'package:pkk/provider/kas_provider.dart';
import 'package:pkk/provider/kegiatan_iuran_provider.dart';
import 'package:pkk/provider/rekap_provider.dart';
import 'package:pkk/provider/user_absence_provider.dart';
import 'package:pkk/provider/user_iuran_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await [Permission.manageExternalStorage, Permission.storage].request();
  initializeDateFormatting('id_ID');
  Intl.defaultLocale = 'id_ID';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BerandaProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AnggotaProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KasProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KegiatanAbsensiProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KegiatanIuranProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserAbsenceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserIuranProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RekapProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangePasswordProvider(),
        ),
      ],
      builder: (context, _) {
        return MaterialApp(
          theme: ThemeData(
            fontFamily: 'NunitoSans',
            brightness: Brightness.light,
            primaryColor: const Color(0xFFF0CC70),
            primaryColorDark: const Color(0xFFFF440A), // prime color
            dialogTheme: const DialogTheme(backgroundColor: Color(0xFFD9DBE3)),
            textTheme: const TextTheme(
              displayLarge: TextStyle(
                color: Colors.white,
              ),
              displayMedium: TextStyle(
                color: Colors.white,
              ),
              displaySmall: TextStyle(
                color: Colors.white,
              ),
              headlineLarge: TextStyle(
                color: Colors.white,
              ),
              headlineMedium: TextStyle(
                color: Colors.white,
              ),
              headlineSmall: TextStyle(
                color: Colors.white,
              ),
              titleLarge: TextStyle(
                color: Colors.white,
              ),
              titleMedium: TextStyle(
                color: Colors.white,
              ),
              titleSmall: TextStyle(
                color: Colors.white,
              ),
              bodyLarge: TextStyle(
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                color: Colors.white,
              ),
              bodySmall: TextStyle(
                color: Colors.white,
              ),
              labelLarge: TextStyle(
                color: Colors.white,
              ),
              labelMedium: TextStyle(
                color: Colors.white,
              ),
              labelSmall: TextStyle(
                color: Colors.white,
              ),
            ).apply(
              bodyColor: const Color(0xFF404C61),
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(0xFFD9D9D9), // secondary color
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color(0xFFFF440A),
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                  const Color(0xFFFFFFFF),
                ),
                backgroundColor: WidgetStateProperty.all(
                  const Color(0xFFFF440A),
                ),
              ),
            ),
            dividerTheme: const DividerThemeData(color: Color(0xFFFF440A)),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}
