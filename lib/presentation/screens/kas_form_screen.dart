import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:pkk/data/res/kas_response.dart';
import 'package:pkk/provider/kas_provider.dart';
import 'package:provider/provider.dart';

class KasFormScreen extends StatefulWidget {
  const KasFormScreen({super.key});

  @override
  State<KasFormScreen> createState() => _KasFormScreenState();
}

class _KasFormScreenState extends State<KasFormScreen> {
  late final GlobalKey<FormBuilderState> formKey;
  @override
  void initState() {
    formKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KasProvider>(context, listen: false).getActivityList();
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
              onRefresh: () => provider.getActivityList(),
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
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FormBuilder(
                        key: formKey,
                        child: Column(
                          children: [
                            FormBuilderDropdown<String>(
                              name: 'kegiatan',
                              decoration: const InputDecoration(
                                hintText: 'Kegiatan',
                              ),
                              items: provider.activityList
                                  .map((e) => DropdownMenuItem(
                                        value: e.id,
                                        child: Text(e.name ?? '-'),
                                      ))
                                  .toList(),
                              validator: FormBuilderValidators.required(),
                            ),
                            FormBuilderTextField(
                              name: 'nominal',
                              decoration: const InputDecoration(
                                hintText: 'Nominal',
                              ),
                              validator: FormBuilderValidators.required(),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              valueTransformer: (value) =>
                                  int.tryParse(value ?? ''),
                            ),
                            FormBuilderTextField(
                              name: 'tujuan',
                              decoration: const InputDecoration(
                                hintText: 'Tujuan',
                              ),
                              validator: FormBuilderValidators.required(),
                            ),
                            FormBuilderDateTimePicker(
                              name: 'tanggal',
                              decoration: const InputDecoration(
                                hintText: 'Tanggal',
                              ),
                              inputType: InputType.date,
                              validator: FormBuilderValidators.required(),
                            ),
                            FormBuilderDropdown<String>(
                              name: 'jenis',
                              decoration: const InputDecoration(
                                hintText: 'Jenis',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'in',
                                  child: Text('Pemasukan'),
                                ),
                                DropdownMenuItem(
                                  value: 'out',
                                  child: Text('Pengeluaran'),
                                ),
                              ],
                              validator: FormBuilderValidators.required(),
                            ),
                            FormBuilderFilePicker(
                              name: 'bukti',
                              maxFiles: 1,
                              decoration: const InputDecoration(
                                labelText: 'Bukti Transaksi',
                              ),
                              validator: FormBuilderValidators.required(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final isValid = formKey.currentState
                                            ?.saveAndValidate() ??
                                        false;
                                    if (!isValid) return;
                                    provider.saveKas(submittedData).then(
                                        (isSuccess) => isSuccess
                                            ? Navigator.of(context).pop()
                                            : null);
                                  },
                                  child: const Text('Simpan'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Kas get submittedData {
    final values = formKey.currentState!.instantValue;
    return Kas(
      activityId: values['kegiatan'],
      nominal: values['nominal'],
      tujuan: values['tujuan'],
      date: values['tanggal'],
      type: values['jenis'],
      localImage: File(values['bukti']?.first.path!),
    );
  }
}
