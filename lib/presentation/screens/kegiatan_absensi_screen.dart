import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pkk/extensions/datetime_ext.dart';
import 'package:pkk/presentation/widgets/app_image_network.dart';
import 'package:pkk/provider/kegiatan_absensi_provider.dart';
import 'package:provider/provider.dart';

class KegiatanAbsensiScreen extends StatefulWidget {
  const KegiatanAbsensiScreen({super.key, required this.activityId});

  final String activityId;

  @override
  State<KegiatanAbsensiScreen> createState() => _KegiatanAbsensiScreenState();
}

class _KegiatanAbsensiScreenState extends State<KegiatanAbsensiScreen> {
  late final GlobalKey<FormBuilderState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KegiatanAbsensiProvider>(context, listen: false)
          .getUserAbsenceList(widget.activityId);
    });
    final themeContext = Theme.of(context);
    return Consumer<KegiatanAbsensiProvider>(
      builder: (context, provider, _) => Scaffold(
        body: FormBuilder(
          key: formKey,
          child: Stack(
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
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  child: RefreshIndicator(
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
                                'Absensi Pengurus PKK',
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
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Kegiatan: ${provider.activity.name ?? '-'}'),
                                  const Divider(),
                                  Text(
                                      'Catatan: ${provider.activity.note ?? '-'}'),
                                  const Divider(),
                                  Text(
                                      'Tanggal: ${provider.activity.date?.toDMmmmYyyy() ?? '-'}'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(12),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                childCount: provider.userElementList.length,
                                (context, index) {
                              final user = provider.userElementList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF9A02),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Column(
                                        children: [
                                          AppImageNetwork(
                                            user.user?.image ?? '',
                                            width: 126,
                                            height: 126,
                                          ),
                                          Text(user.user?.name ?? '-'),
                                          Text(user.user?.role ?? '-'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 28),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF9A02),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: FormBuilderCheckbox(
                                          name: user.userId!,
                                          initialValue: user.isAttended == 1,
                                          title: const Text('Hadir'),
                                          onChanged: (value) async {
                                            if (value == null) return;
                                            if (value ==
                                                (user.isAttended == 1)) {
                                              return;
                                            }
                                            final isSuccess = await provider
                                                .updateUserAbsenceStatus(
                                              id: user.absenceId,
                                              userIndex: index,
                                              isAttended: value,
                                            );
                                            if (!isSuccess) {
                                              formKey.currentState!
                                                  .fields[user.userId]!
                                                  .didChange(!value);
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                    onRefresh: () =>
                        provider.getUserAbsenceList(widget.activityId),
                  ),
                ),
              ),
              if (provider.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
