import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/presentation/widgets/app_image_network.dart';
import 'package:pkk/provider/anggota_provider.dart';
import 'package:provider/provider.dart';

class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({super.key});

  @override
  State<AnggotaScreen> createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  late final AnggotaProvider provider;
  // final List<String> items =
  //     List<String>.generate(20, (i) => 'Item $i Item $i'); // for develop

  @override
  void initState() {
    super.initState();

    provider = Provider.of<AnggotaProvider>(context, listen: false);

    try {
      provider.getUsersList();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Consumer<AnggotaProvider>(
      builder: (context, provider, _) {
        final users = provider.listUsers;
        return Scaffold(
          body: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: themeContext.colorScheme.secondary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: themeContext.primaryColor,
                    ),
                  ),
                ],
              ),
              RefreshIndicator(
                onRefresh: () => provider.getUsersList(),
                child: CustomScrollView(
                  // CONTENTS
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: const Color(0x55FFFFFF),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Text(
                            'Anggota Pengurus PKK',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final user = users[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 8,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                // height: 125,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 10.0,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color(0xCBFF9A02),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AppImageNetwork(
                                          user.image ??
                                              'assets/images/pkk-logo.png',
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          // Jabatan
                                          user.name ?? '-',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            user.phone ?? '-',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            user.jabatan ?? '-',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (Preferences.getUser()?.role ==
                                                  'admin')
                                                Switch(
                                                  value: user.isActive == 1,
                                                  inactiveTrackColor:
                                                      Colors.grey,
                                                  onChanged: (_) async {
                                                    final isSuccess = await provider
                                                        .changeUserStatus(
                                                            user.id!,
                                                            isActive: !(user
                                                                    .isActive ==
                                                                1));
                                                    Fluttertoast.showToast(
                                                      msg: isSuccess
                                                          ? 'Ubah status anggota berhasil'
                                                          : 'Gagal ubah status anggota',
                                                    );
                                                  },
                                                ),
                                              // Container(
                                              // padding:
                                              //     const EdgeInsets.symmetric(
                                              //   horizontal: 6.0,
                                              //   vertical: 3.0,
                                              // ),
                                              // decoration: BoxDecoration(
                                              //   color: themeContext
                                              //       .primaryColorDark,
                                              //   borderRadius:
                                              //       BorderRadius.circular(10.0),
                                              // ),
                                              // child:
                                              Text(
                                                user.isActive == 1
                                                    ? 'Aktif'
                                                    : 'Tidak Aktif',
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                              // ),
                                            ],
                                          ),
                                          if (Preferences.getUser()?.role ==
                                              'admin')
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    final isSuccess =
                                                        await provider
                                                            .resetPassword(
                                                                user.id!);
                                                    Fluttertoast.showToast(
                                                      msg: isSuccess
                                                          ? 'Reset sandi berhasil'
                                                          : 'Gagal reset sandi',
                                                    );
                                                  },
                                                  child:
                                                      const Text('Reset sandi'),
                                                ),
                                                IconButton.filled(
                                                  style: IconButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.red),
                                                  onPressed: () async {
                                                    final isSuccess =
                                                        await showDialog<bool?>(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: const Text(
                                                            'Apakah anda yakin ingin menghapus anggota ini?',
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                              child: const Text(
                                                                  'Batal'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () => provider
                                                                  .deleteUser(
                                                                      user.id!)
                                                                  .then((isSuccess) =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(
                                                                              isSuccess)),
                                                              child: const Text(
                                                                  'Hapus'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    if (isSuccess == null)
                                                      return;
                                                    Fluttertoast.showToast(
                                                      msg: isSuccess
                                                          ? 'Hapus anggota berhasil'
                                                          : 'Gagal hapus anggota',
                                                    );
                                                  },
                                                  icon:
                                                      const Icon(Icons.delete),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: users.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
