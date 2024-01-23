import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:force_update_example/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MandatoryUpdateScreen extends StatelessWidget {
  const MandatoryUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Update Required",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              const Icon(
                CupertinoIcons.arrow_up_right_diamond_fill,
                size: 160,
                color: Colors.black,
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Update the app to get the latest features",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              if (storeUrl != null)
                ElevatedButton(
                  onPressed: () {
                    launchUrl(
                      Uri.parse(storeUrl!),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: const Text("Update Now"),
                ),
              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }
}
