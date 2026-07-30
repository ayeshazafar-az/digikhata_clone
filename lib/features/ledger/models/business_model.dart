import 'package:isar/isar.dart';

part 'business_model.g.dart';

@collection
class BusinessModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId;

  late String ownerId;
  late String businessName;
  String? businessType;

  late DateTime createdAt;

  bool isSynced = false;
}
