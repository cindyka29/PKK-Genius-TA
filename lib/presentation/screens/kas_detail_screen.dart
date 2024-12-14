import 'package:flutter/material.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/extensions/datetime_ext.dart';
import 'package:pkk/extensions/number_ext.dart';
import 'package:pkk/presentation/widgets/app_image_network.dart';
import 'package:pkk/provider/kas_provider.dart';
import 'package:provider/provider.dart';

class KasDetailScreen extends StatelessWidget {
  const KasDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KasProvider>(context, listen: false).getKasDetail();
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
                        'Detail Kas Umum',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: RefreshIndicator(
                    onRefresh: () => provider.getKasDetail(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Align(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  provider.kasDetail.activity?.name ?? '-',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 42),
                              Text(
                                  'Nama Kegiatan: ${provider.kasDetail.activity?.name ?? '-'}'),
                              const Divider(),
                              Text(
                                  'Tanggal: ${provider.kasDetail.date?.toDMmmmYyyy() ?? '-'}'),
                              const Divider(),
                              Text(
                                  'Tujuan: ${provider.kasDetail.tujuan ?? '-'}'),
                              const Divider(),
                              Text(
                                  'Jenis: ${provider.kasDetail.typeLabel ?? '-'}'),
                              const Divider(),
                              Text(
                                  'Nominal: ${provider.kasDetail.nominal?.toIndonesianFormat() ?? '-'}'),
                              const Center(
                                child: Text('Bukti Transaksi'),
                              ),
                              Center(
                                child: AppImageNetwork(
                                  provider.kasDetail.image?.url ?? '',
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                              if (Preferences.getUser()?.role == 'admin')
                                ElevatedButton(
                                  onPressed: () async {
                                    final isSuccess = await provider
                                        .deleteKas(provider.kasDetail.id!);

                                    if (isSuccess) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Hapus Kas'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
