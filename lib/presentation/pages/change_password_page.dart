import 'package:flutter/material.dart';
import 'package:pkk/provider/change_password_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final GlobalKey<FormState> formKey;
  // late final TextEditingController oldPasswordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController confirmNewPasswordController;

  @override
  void initState() {
    formKey = GlobalKey();
    // oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Password'),
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
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    // TextFormField(
                    //   controller: oldPasswordController,
                    //   obscureText: true,
                    //   decoration: const InputDecoration(hintText: 'Sandi lama'),
                    //   validator: (value) =>
                    //       (value?.isEmpty ?? true) ? 'Harus diisi' : null,
                    // ),
                    // const SizedBox(height: 8),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Sandi Baru'),
                      validator: (value) =>
                          (value?.isEmpty ?? true) ? 'Harus diisi' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: confirmNewPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Konfirmasi Sandi Baru'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Harus diisi';
                        }
                        if (value != newPasswordController.text) {
                          return 'Sandi baru dan konfirmasi harus sama';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (!(formKey.currentState!.validate())) return;
                        final provider = Provider.of<ChangePasswordProvider>(
                            context,
                            listen: false);
                        provider
                            .changePassword(
                          // oldPassword: oldPasswordController.text,
                          newPassword: newPasswordController.text,
                        )
                            .then((isSuccess) {
                          setState(() {
                            // oldPasswordController.clear();
                            newPasswordController.clear();
                            confirmNewPasswordController.clear();
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Password berhasil diubah'),
                          ));
                        });
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Selector<ChangePasswordProvider, bool>(
            builder: (context, isLoading, _) {
              return Positioned.fill(
                child: Visibility(
                  visible: isLoading,
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            },
            selector: (p0, p1) => p1.isLoading,
          ),
          Selector<ChangePasswordProvider, String>(
            builder: (context, errorMessage, _) {
              if (errorMessage.isNotEmpty) {
                final snackBar = SnackBar(content: Text(errorMessage));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              return const SizedBox();
            },
            selector: (p0, p1) => p1.errorMessage,
          ),
        ],
      ),
    );
  }
}
