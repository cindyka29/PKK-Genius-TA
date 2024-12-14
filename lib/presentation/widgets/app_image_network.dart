import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:pkk/data/api/api_client.dart';

class AppImageNetwork extends StatelessWidget {
  const AppImageNetwork(this.src,
      {super.key, required, this.width, this.height, this.fit});

  final String src;
  final double? width;
  final double? height;
  final BoxFit? fit;

  Future<File> _fetchAndCacheImage(String url) async {
    var cacheManager = ApiClient.cacheManager;
    var file = await cacheManager.getSingleFile(url);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _fetchAndCacheImage(src),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding:
                EdgeInsets.all(max((min(width ?? 0, height ?? 0)) * 0.1, 10)),
            width: width,
            height: height,
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          return Image.file(
            snapshot.data!,
            width: width,
            height: height,
          );
        } else {
          return Container(
            width: width,
            height: height,
            color: Colors.grey,
            child: const Icon(Icons.warning),
          );
        }
      },
    );
  }
}
