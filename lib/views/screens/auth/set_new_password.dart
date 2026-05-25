import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saka/providers/auth/auth.dart';
import 'package:saka/utils/color_resources.dart';
import 'package:saka/utils/custom_themes.dart';
import 'package:saka/utils/dimensions.dart';
import 'package:saka/views/basewidgets/loader/circular.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String email;

  const SetNewPasswordScreen({super.key, required this.email});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController newPasswordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();

  bool obscureNew = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    newPasswordC.dispose();
    confirmPasswordC.dispose();
    super.dispose();
  }

  Future<void> submit(BuildContext context) async {
    if (newPasswordC.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 8 karakter")),
      );
      return;
    }

    if (newPasswordC.text != confirmPasswordC.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konfirmasi password tidak sesuai")),
      );
      return;
    }

    await Provider.of<AuthProvider>(context, listen: false).forgotPasswordReset(
      context,
      newPasswordC.text.trim(),
      confirmPasswordC.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.brown,
      appBar: AppBar(
        backgroundColor: ColorResources.brown,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorResources.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Atur Password Baru",
                  style: robotoRegular.copyWith(
                    color: ColorResources.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.email,
                  style: robotoRegular.copyWith(
                    color: ColorResources.white,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: newPasswordC,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    hintText: "Password baru",
                    fillColor: ColorResources.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => obscureNew = !obscureNew),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPasswordC,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    hintText: "Konfirmasi password baru",
                    fillColor: ColorResources.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => obscureConfirm = !obscureConfirm),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: ColorResources.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => submit(context),
                    child:
                        authProvider.forgotPasswordStatus ==
                            ForgotPasswordStatus.loading
                        ? Loader(color: ColorResources.white)
                        : Text(
                            "Simpan Password",
                            style: robotoRegular.copyWith(
                              color: ColorResources.white,
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
