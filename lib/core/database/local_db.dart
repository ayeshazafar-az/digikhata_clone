import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/ledger/models/business_model.dart';
import '../../features/customers/models/party_model.dart';
import '../../features/ledger/models/ledger_entry_model.dart';
import '../../features/ledger/models/cash_book_model.dart';

class LocalDb {
  static Isar? isar;

  static Future<void> init() async {
    if (kIsWeb) {
      // Isar is not strictly required on Web Admin panel and requires extra wasm setup.
      // Bypassing Isar init on Web to prevent crash on launch.
      return;
    }

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
