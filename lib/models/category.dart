import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late DateTime createdAt;

  Category({
    String? id,
    required this.name,
    DateTime? createdAt,
  }) {
    this.id = id ?? const Uuid().v4();
    this.createdAt = createdAt ?? DateTime.now();
  }
}
