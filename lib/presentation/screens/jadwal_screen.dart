import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pkk/data/model/activity_datasource.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/data/res/activities_response.dart';
import 'package:pkk/data/res/program_response.dart';
import 'package:pkk/presentation/screens/kegiatan_absensi_screen.dart';
import 'package:pkk/presentation/screens/kegiatan_iuran_screen.dart';
import 'package:pkk/presentation/screens/rekap_iuran_screen.dart';
import 'package:pkk/provider/beranda_provider.dart';
import 'package:pkk/provider/rekap_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

enum _ScreenState { show, add }

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  late ActivityDatasource _dataSource = ActivityDatasource([]);

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    final provider = Provider.of<BerandaProvider>(context, listen: false);

    if (provider.listActivity.isNotEmpty) {
      _dataSource = ActivityDatasource(provider.listActivity);
    } else {
      try {
        Future.wait([
          provider.fetchActivity().then(
            (value) {
              _dataSource = ActivityDatasource(provider.listActivity);
            },
          ),
          provider.fetchProgram(),
        ]);
      } catch (e) {
        debugPrint('Error Loading data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ValueNotifier<CalendarTapDetails?>(null),
        ),
        ChangeNotifierProvider(
          create: (context) => ValueNotifier<_ScreenState>(_ScreenState.show),
        ),
      ],
      builder: (context, _) {
        final calendarTapDetailsNotifier =
            Provider.of<ValueNotifier<CalendarTapDetails?>>(context,
                listen: false);
        final screenStateNotifier =
            Provider.of<ValueNotifier<_ScreenState>>(context, listen: false);
        return Consumer<BerandaProvider>(
          builder: (context, provider, child) {
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
                  Padding(
                    padding: const EdgeInsets.all(16.0).copyWith(
                      bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          flex: 5,
                          child: SfCalendar(
                            view: CalendarView.month,
                            dataSource: _dataSource,
                            monthViewSettings: const MonthViewSettings(
                              appointmentDisplayMode:
                                  MonthAppointmentDisplayMode.indicator,
                            ),
                            backgroundColor: Colors.white,
                            todayHighlightColor: Colors.red,
                            showNavigationArrow: true,
                            onTap: (calendarTapDetails) {
                              calendarTapDetailsNotifier.value =
                                  calendarTapDetails;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          flex: 4,
                          child: Selector<ValueNotifier<_ScreenState>,
                              _ScreenState>(
                            selector: (p0, p1) => p1.value,
                            builder: (context, state, _) {
                              switch (state) {
                                case _ScreenState.show:
                                  return Selector<
                                      ValueNotifier<CalendarTapDetails?>,
                                      List<Activity>>(
                                    selector: (p0, p1) =>
                                        p1.value?.appointments
                                            ?.cast<Activity>() ??
                                        <Activity>[],
                                    shouldRebuild: (previous, next) =>
                                        !listEquals(previous, next),
                                    builder: (context, value, child) {
                                      return RefreshIndicator(
                                        onRefresh: () async => getData(),
                                        child: _KegiatanListView(
                                            activityList: value),
                                      );
                                    },
                                  );
                                case _ScreenState.add:
                                  return _KegiatanFormWidget(
                                    programOptions: provider.listProgram,
                                    calendarTapDetailsNotifier:
                                        calendarTapDetailsNotifier,
                                    onSubmit: (activity) async {
                                      final isSuccess =
                                          await provider.saveActivity(activity);
                                      if (!isSuccess) return;
                                      screenStateNotifier.value =
                                          _ScreenState.show;
                                    },
                                    onCancel: () => screenStateNotifier.value =
                                        _ScreenState.show,
                                  );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: Preferences.getUser()?.role == 'admin'
                  ? Selector<ValueNotifier<_ScreenState>, _ScreenState>(
                      selector: (p0, p1) => p1.value,
                      builder: (context, state, _) {
                        return Visibility(
                          visible: state == _ScreenState.show,
                          child: FloatingActionButton(
                            onPressed: () =>
                                screenStateNotifier.value = _ScreenState.add,
                            heroTag: UniqueKey(),
                            backgroundColor: themeContext.primaryColorDark,
                            child: const Icon(
                              Icons.add_outlined,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    )
                  : null, // add fab to admin only
            );
          },
        );
      },
    );
  }
}

class _KegiatanListView extends StatelessWidget {
  const _KegiatanListView({required this.activityList});

  final List<Activity> activityList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: activityList.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        final data = activityList[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activity: ${data.name ?? '-'}'),
              const Divider(),
              Text('Catatan: ${data.note ?? '-'}'),
              const Divider(),
              Text('Program: ${data.program?.name ?? '-'}'),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => KegiatanAbsensiScreen(
                            activityId: data.id!,
                          ),
                        ),
                      );
                    },
                    child: const Text('Absensi'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => KegiatanIuranScreen(
                            activityId: data.id!,
                          ),
                        ),
                      );
                    },
                    child: const Text('Iuran'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<RekapProvider>(context, listen: false);
                      provider.getlistRekapIuran(activityId: data.id!);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RekapIuranScreen(),
                        ),
                      );
                    },
                    child: const Text('Rekap'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class _KegiatanFormWidget extends StatefulWidget {
  const _KegiatanFormWidget({
    required this.programOptions,
    required this.calendarTapDetailsNotifier,
    required this.onSubmit,
    required this.onCancel,
  });

  final List<Program> programOptions;
  final ValueNotifier<CalendarTapDetails?> calendarTapDetailsNotifier;
  final void Function(Activity) onSubmit;
  final VoidCallback onCancel;

  @override
  State<_KegiatanFormWidget> createState() => _KegiatanFormWidgetState();
}

class _KegiatanFormWidgetState extends State<_KegiatanFormWidget> {
  late final GlobalKey<FormBuilderState> formKey;

  @override
  void initState() {
    formKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FormBuilder(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              name: 'kegiatan',
              decoration: const InputDecoration(hintText: 'Kegiatan'),
              validator: FormBuilderValidators.required(),
            ),
            FormBuilderTextField(
              name: 'catatan',
              decoration: const InputDecoration(hintText: 'Catatan'),
              validator: FormBuilderValidators.required(),
            ),
            FormBuilderDropdown(
              name: 'program',
              decoration: const InputDecoration(hintText: 'Program'),
              items: widget.programOptions
                  .map((e) => DropdownMenuItem(
                      value: e.id!, child: Text(e.name ?? '-')))
                  .toList(),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Batal'),
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
            )
          ],
        ),
      ),
    );
  }

  Activity get submittedData {
    final values = formKey.currentState!.instantValue;
    return Activity(
      name: values['kegiatan'] as String,
      note: values['catatan'] as String,
      programId: values['program'] as String,
      date: widget.calendarTapDetailsNotifier.value?.date,
    );
  }
}
