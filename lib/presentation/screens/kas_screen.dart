import 'package:flutter/material.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/data/res/kas_response.dart';
import 'package:pkk/presentation/screens/kas_detail_screen.dart';
import 'package:pkk/presentation/screens/kas_form_screen.dart';
import 'package:pkk/presentation/widgets/app_image_network.dart';
import 'package:pkk/provider/kas_provider.dart';
import 'package:provider/provider.dart';

class KasScreen extends StatefulWidget {
  const KasScreen({super.key});

  @override
  State<KasScreen> createState() => _KasScreenState();
}

class _KasScreenState extends State<KasScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KasProvider>(context, listen: false).getKasMonths();
    });

    final themeContext = Theme.of(context);

    return Consumer<KasProvider>(
      builder: (context, provider, _) => Scaffold(
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
              onRefresh: () => provider.getKasMonths(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                          'Kas Umum',
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
                        (BuildContext context, int index) {
                          final month = provider.kasMonths[index];
                          return GestureDetector(
                            onTap: () {
                              provider
                                  .getKasList(
                                      monthCode: provider.kasMonthMap[month]!)
                                  .then(
                                (_) {
                                  _KasListCard.show(
                                    context: context,
                                    monthStr: month,
                                    kasList: provider.kasList,
                                    onTap: (kas) {
                                      assert(kas.id != null);
                                      provider.kasIdSelected = kas.id!;
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const KasDetailScreen(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 8,
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                height: 150,
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
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 6.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            themeContext.colorScheme.secondary,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        month,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () => provider
                                                    .downloadKasMonthlyReport(
                                                        provider.kasMonthMap[
                                                            month]!),
                                                icon: const Icon(
                                                    Icons.document_scanner),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: provider.kasMonths.length,
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
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
        floatingActionButton: Preferences.getUser()?.role == 'admin'
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const KasFormScreen(),
                    ),
                  );
                },
                heroTag: UniqueKey(),
                backgroundColor: themeContext.primaryColorDark,
                child: const Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                ),
              )
            : null, // add fab to admin only
      ),
    );
  }
}

class _KasListCard extends StatelessWidget {
  const _KasListCard(
      {required this.monthStr, required this.kasList, required this.onTap});

  final String monthStr;
  final List<Kas> kasList;
  final void Function(Kas) onTap;

  static Future<void> show({
    required BuildContext context,
    required String monthStr,
    required List<Kas> kasList,
    required void Function(Kas) onTap,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: _KasListCard(
          monthStr: monthStr,
          kasList: kasList,
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(monthStr),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final kas = kasList[index];
                return GestureDetector(
                  onTap: () => onTap(kas),
                  child: Row(
                    children: [
                      AppImageNetwork(
                        kas.image?.url ?? '',
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Kegiatan ${kas.activity?.name ?? '-'}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 15);
              },
              itemCount: kasList.length,
            ),
          ),
        ],
      ),
    );
  }
}
