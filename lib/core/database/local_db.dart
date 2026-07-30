import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/ledger/models/business_model.dart';
import '../../features/customers/models/party_model.dart';
import '../../features/ledger/models/ledger_entry_model.dart';
import '../../features/ledger/models/cash_book_model.dart';

class LocalDb {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        BusinessModelSchema,
        PartyModelSchema,
        LedgerEntryModelSchema,
        CashBookModelSchema,
      ],
      directory: dir.path,
    );
  }
}
