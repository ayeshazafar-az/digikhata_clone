import 'package:isar/isar.dart';

part 'ledger_entry_model.g.dart';

@collection
class LedgerEntryModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId;

  @Index()
  String? remotePartyId;
  int? localPartyId;

  late double amount;

  // 'credit' or 'debit'
  late String entryType;

  String? description;

  late DateTime entryDate;

  // 'pending' or 'synced'
  String syncStatus = 'pending';

  late DateTime createdAt;
}
