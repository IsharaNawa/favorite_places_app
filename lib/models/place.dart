import 'package:uuid/uuid.dart';

const idGenerator = Uuid();

class Place {
  Place({required this.name}) : id = idGenerator.v4();

  String id;
  String name;
}
