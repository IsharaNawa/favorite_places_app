import 'dart:io';

import 'package:uuid/uuid.dart';

const idGenerator = Uuid();

class Place {
  Place({required this.name, required this.image}) : id = idGenerator.v4();

  final String id;
  final String name;
  final File image;
}
