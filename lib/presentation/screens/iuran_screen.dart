import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pkk/global/global_variable.dart';
import 'package:pkk/provider/user_iuran_provider.dart';
import 'package:provider/provider.dart';

class IuranScreen extends StatefulWidget {
  const IuranScreen({super.key});

  @override
  State<IuranScreen> createState() => _IuranScreenState();
}

class _IuranScreenState extends State<IuranScreen> {
  final List<String> items =
      List<String>.generate(10, (i) => 'Item $i Item $i'); // for develop

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<UserIuranProvider>(context, listen: false);

    try {
      provider.getIuran();
    } catch (e, stacktrace) {
      debugPrint('Failed to load iuran user data: $e\n$stacktrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Consumer<UserIuranProvider>(
      builder: (context, provider, _) {
        final listIuran = provider.listIuran;
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
                          'Record Iuran',
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
                          final data = listIuran[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 8,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(
                              // height: MediaQuery.of(context).size.height / 6,
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
                                        // Jabatan
                                        data.activity?.name ?? '-',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        // Jabatan
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
                                      data.isPaid == 1
                                          ? 'Lunas'
                                          : 'Belum Lunas',
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
                        childCount: listIuran.length,
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
