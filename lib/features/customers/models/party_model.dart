import 'package:isar/isar.dart';

part 'party_model.g.dart';

@collection
class PartyModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId;

  @Index()
  String? remoteBusinessId;
  int? localBusinessId;

  late String name;
  String? phone;

  // 'customer' or 'supplier'
  late String type;

  late DateTime createdAt;

  bool isSynced = false;
}
