import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pkk/data/api/user_function.dart';
import 'package:pkk/data/enum/jabatan.dart';

class TambahAnggotaScreen extends StatefulWidget {
  const TambahAnggotaScreen({super.key});

  @override
  State<TambahAnggotaScreen> createState() => _TambahAnggotaScreenState();
}

class _TambahAnggotaScreenState extends State<TambahAnggotaScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  File? _image;
  Jabatan? _jabatan;
  bool _isActive = true;
  final ImagePicker _picker = ImagePicker();

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Icon(
                Icons.cancel_outlined,
                size: 75,
              ),
              Text(
                'Maaf',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF404C61),
                ),
              ),
            ],
          ),
          content: const Text(
            'Data anggota belum berhasil masuk',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Icon(
                Icons.check_circle,
                size: 75,
              ),
              Text(
                'Selamat!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF404C61),
                ),
              ),
            ],
          ),
          content: const Text(
            'Data berhasil dimasukkan',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addUser() async {
    setState(() {
      _isLoading = true;
    });

    final trimmedName = _nameController.text.replaceAll(RegExp(r'\s+'), '');

    FormData formData = FormData.fromMap({
      'username': trimmedName,
      'name': _nameController.text,
      'phone': _phoneController.text,
      'password': '123456',
      'password_confirmation': '123456',
      'role': 'user',
      'jabatan': _jabatan?.label,
      'image': await MultipartFile.fromFile(
        _image!.path,
        filename: _image!.path,
      ),
      'is_active': _isActive ? 1 : 0,
    });

    // debugPrint(_formData);

    try {
      final result = await UserFunction.addUser(
        formData: formData,
      );

      // debugPrint('$_formData');

      if (result) {
        setState(() {
          _nameController.text = '';
          _phoneController.text = '';
          _jabatan = null;
          _image = null;
        });
        _showSuccessDialog();
      } else {
        _showConfirmationDialog();
      }
    } catch (e) {
      debugPrint('Error when hitting Daftarkan button: ${e.toString()}');
      _showConfirmationDialog();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

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
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Buat akun untuk anggota baru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Buat akun baru untuk penggunaan di masa mendatang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: const Color(0x99FFFFFF),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            cursorColor: themeContext.primaryColorDark,
                            decoration: InputDecoration(
                              hintText: 'Nama',
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: themeContext.primaryColorDark,
                                ),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: _phoneController,
                            cursorColor: themeContext.primaryColorDark,
                            decoration: InputDecoration(
                              hintText: 'No. Telepon',
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: themeContext.primaryColorDark,
                                ),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          DropdownButton<Jabatan>(
                            hint: const Text('Pilih Jabatan'),
                            value: _jabatan,
                            onChanged: (jabatan) {
                              setState(() {
                                _jabatan = jabatan;
                              });
                            },
                            items: Jabatan.values.map((jabatan) {
                              return DropdownMenuItem<Jabatan>(
                                value: jabatan,
                                child: Text(jabatan.label),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 30),

                          // Add the image picker section here
                          _image == null
                              ? const Text('No image selected.')
                              : SizedBox(
                                  width: 200, // Set the desired width
                                  height: 200, // Set the desired height
                                  child: Image.file(_image!,
                                      fit: BoxFit
                                          .cover // You can adjust the fit property as needed
                                      ),
                                ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => _pickImage(ImageSource.camera),
                                child: const Text('Camera'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                child: const Text('Gallery'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SwitchListTile(
                            value: _isActive,
                            title: const Text('Aktif'),
                            onChanged: (_) {
                              setState(() {
                                _isActive = !_isActive;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : FilledButton(
                              onPressed: _addUser,
                              // _login,
                              child: const Text('Daftarkan'),
                            ),
                    ),
                    // const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
