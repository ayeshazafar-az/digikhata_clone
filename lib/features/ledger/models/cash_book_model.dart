import 'package:isar/isar.dart';

part 'cash_book_model.g.dart';

@collection
class CashBookModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? remoteId;

  @Index()
  String? remoteBusinessId;
  int? localBusinessId;

  late double amount;

  // 'cash_in' or 'cash_out'
  late String cashType;

  String? remarks;

  late DateTime entryDate;
  late DateTime createdAt;

  // 'pending' or 'synced'
  String syncStatus = 'pending';
}
