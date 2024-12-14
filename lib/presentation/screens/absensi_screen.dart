import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pkk/global/global_variable.dart';
import 'package:pkk/provider/user_absence_provider.dart';
import 'package:provider/provider.dart';

class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({super.key});

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  final List<String> items =
      List<String>.generate(10, (i) => 'Item $i Item $i'); // for develop

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<UserAbsenceProvider>(context, listen: false);

    try {
      provider.getAbsences();
    } catch (e, stacktrace) {
      debugPrint('Failed to load absence user data: $e\n$stacktrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Consumer<UserAbsenceProvider>(
      builder: (context, provider, _) {
        final listAbsence = provider.listAbsence;
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
              CustomScrollView(
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
                          'Record Absen',
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
                          final data = listAbsence[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 8,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(
                              // height: MediaQuery.of(context).size.height / 5,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/images/pkk-logo.png',
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        // Nama Kegiatan
                                        data.activity?.name ?? '-',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      // Tanggal Kegiatan
                                      Text(
                                        data.activity?.date != null
                                            ? DateFormat(formatDate)
                                                .format(data.activity!.date!)
                                                .toString()
                                            : '-',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 3.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: themeContext.primaryColorDark,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      data.isAttended == 1
                                          ? 'Hadir'
                                          : 'Tidak Hadir',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        // childCount: 1,
                        childCount: listAbsence.length,
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
            ],
          ),
        );
      },
    );
  }
}
