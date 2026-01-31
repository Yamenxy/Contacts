import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ContactImageSource {
  asset,
  file,
}

@immutable
class Contact {
  const Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.imagePath,
    required this.imageSource,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String imagePath;
  final ContactImageSource imageSource;

  ImageProvider get imageProvider {
    if (imageSource == ContactImageSource.asset) {
      return AssetImage(imagePath);
    }

    if (kIsWeb) {
      return const AssetImage('assets/Person_1.png');
    }

    return FileImage(File(imagePath));
  }
}
