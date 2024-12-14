import 'package:flutter/material.dart';
import 'package:pkk/data/api/api_client.dart';
import 'package:pkk/data/res/documentations_response.dart';
import 'package:pkk/data/res/iuran_report_response.dart';
import 'package:pkk/data/res/kas_response.dart';
import 'package:pkk/extensions/number_ext.dart';
import 'package:pkk/global/global_variable.dart';
import 'package:pkk/presentation/widgets/app_image_network.dart';
import 'package:pkk/provider/beranda_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  // final List<String> items =
  //     List<String>.generate(10, (i) => 'Item $i Item $i'); // for develop

  @override
  void initState() {
    super.initState();
    getData(context);
  }

  Future<void> getData(BuildContext context) async {
    final provider = Provider.of<BerandaProvider>(context, listen: false);
    try {
      provider.getAllBerandaData();
    } catch (e) {
      debugPrint('Error Loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);
    final appBarHeight = AppBar().preferredSize.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final totalAppBarHeight = appBarHeight + topPadding;

    return Consumer<BerandaProvider>(
      builder: (context, provider, _) {
        final listProgram = provider.listProgram;
        final listActivity = provider.listActivity
            .where((act) => (act.date!.isAfter(DateTime.now()) ||
                act.date!.isAtSameMomentAs(DateTime.now())))
            .toList();
        final listDocs = provider.listActivityDocs
            .where(
              (element) => element.documentations.isNotEmpty,
            )
            .toList();

        return Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 3,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
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
              Positioned(
                top: totalAppBarHeight,
                bottom: 0,
                left: 10,
                right: 10,
                child: RefreshIndicator(
                  onRefresh: () async => await getData(context),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      child: Column(
                        children: [
                          // PROGRAM PKK
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 10.0,
                            ),
                            child: const Text(
                              'Program Pokok PKK',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF404C61),
                              ),
                            ),
                          ),
                          SizedBox(
                            // width: MediaQuery.of(context).size.width / 3,
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listProgram.length,
                              itemBuilder: (context, index) {
                                final program = listProgram[index];
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: InkWell(
                                    onTap: () {
                                      // change when already page for this card
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: AppImageNetwork(
                                              program.image?.url ??
                                                  'assets/images/pkk-logo.png',
                                              fit: BoxFit.contain,
                                            ),
                                            content: Column(
                                              // direction: Axis.vertical,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xCBFF9A02),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(25.0),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    program.name ?? '-',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                Text(
                                                  program.note ?? '-',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      elevation: 8,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        height: double.infinity,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: const BoxDecoration(
                                          color: Color(0xCBFF9A02),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25.0),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: AppImageNetwork(
                                                program.image?.url ??
                                                    'assets/images/pkk-logo.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 7.0,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFF440A),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(25.0),
                                                  ),
                                                ),
                                                child: Text(
                                                  program.name ?? '-',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(
                            height: 50,
                            thickness: 2,
                            color: Colors.white,
                          ),
                          // JADWAL KEGIATAN
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10.0),
                            child: const Text(
                              'Jadwal Kegiatan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF404C61),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width / 4,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listActivity.length,
                              itemBuilder: (BuildContext context, int index) {
                                final activity = listActivity[index];
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 8,
                                    child: Container(
                                      alignment: Alignment.center,
                                      // width: 120,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: const BoxDecoration(
                                        color: Color(0xCBFF9A02),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(DateFormat(formatDate)
                                              .format(activity.date!)
                                              .toString()),
                                          Text(
                                            activity.name ?? '-',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          // const SizedBox(
                                          //   height: 12,
                                          // ),
                                        ],
                                      ),
                                      // THINKING OUT SIDE THE BOX LIKE THIS DATE
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // DOKUMENTASI KEGIATAN
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10.0),
                            child: const Text(
                              'Dokumentasi Kegiatan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF404C61),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 140,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: listDocs.length,
                              itemBuilder: (context, index) {
                                final activityDocs = listDocs[index];
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GestureDetector(
                                    onTap: () => _DocumentationListCard.show(
                                      context: context,
                                      name: activityDocs.name,
                                      imageList: activityDocs.documentations,
                                    ),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      elevation: 8,
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xCBFF9A02),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(25.0),
                                          ),
                                          image: DecorationImage(
                                            image: const AssetImage(
                                              'assets/images/pkk-logo.png',
                                            ), // change when already got an image
                                            fit: BoxFit.contain,
                                            colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.6),
                                              BlendMode.darken,
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFF440A),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(25.0),
                                            ),
                                          ),
                                          child: Text(
                                            activityDocs.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0,
                                            ),
                                          ),
                                        ),
                                        // THINKING OUT SIDE THE BOX LIKE THIS DATE
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // GRAFIK KAS
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10.0),
                            child: const Text(
                              'Grafik Kas Umum dan Iuran',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF404C61),
                              ),
                            ),
                          ),
                          Container(
                            height: 250,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SfCartesianChart(
                              primaryYAxis: NumericAxis(
                                axisLabelFormatter: (axisLabelRenderArgs) {
                                  return ChartAxisLabel(
                                    axisLabelRenderArgs.value
                                        .toIndonesianFormat(),
                                    null,
                                  );
                                },
                              ),
                              primaryXAxis: const DateTimeAxis(),
                              legend: const Legend(isVisible: true),
                              series: <CartesianSeries>[
                                // Renders line chart
                                if (provider.kasReportData.kasIn?.isNotEmpty ??
                                    false)
                                  LineSeries<Kas, DateTime>(
                                    name: 'Pemasukan Kas Umum',
                                    dataSource:
                                        provider.kasReportData.kasIn ?? [],
                                    xValueMapper: (data, _) => data.date,
                                    yValueMapper: (data, _) => data.nominal,
                                  ),
                                if (provider.kasReportData.kasOut?.isNotEmpty ??
                                    false)
                                  LineSeries<Kas, DateTime>(
                                    name: 'Pengeluaran Kas Umum',
                                    dataSource:
                                        provider.kasReportData.kasOut ?? [],
                                    xValueMapper: (data, _) => data.date,
                                    yValueMapper: (data, _) => data.nominal,
                                  ),
                                if (provider.iuranReportData.dataIn.isNotEmpty)
                                  LineSeries<Iuran, DateTime>(
                                    name: 'Pemasukan Iuran',
                                    dataSource: provider.iuranReportData.dataIn,
                                    xValueMapper: (data, _) => data.date,
                                    yValueMapper: (data, _) => data.nominal,
                                  ),
                                if (provider.iuranReportData.out.isNotEmpty)
                                  LineSeries<Iuran, DateTime>(
                                    name: 'Pengeluaran Kas Umum',
                                    dataSource: provider.iuranReportData.out,
                                    xValueMapper: (data, _) => data.date,
                                    yValueMapper: (data, _) => data.nominal,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DocumentationListCard extends StatelessWidget {
  const _DocumentationListCard({required this.name, required this.imageList});

  final String name;
  final List<Documentation> imageList;

  static Future<void> show({
    required BuildContext context,
    required String name,
    required List<Documentation> imageList,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: _DocumentationListCard(
          name: name,
          imageList: imageList,
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
            child: Text(name),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final image = imageList[index];
                return Row(
                  children: [
                    AppImageNetwork(
                      '${ApiClient.baseUrl}${image.url}',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        image.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 15);
              },
              itemCount: imageList.length,
            ),
          ),
        ],
      ),
    );
  }
}
