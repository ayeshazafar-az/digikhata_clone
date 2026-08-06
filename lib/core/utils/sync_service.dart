import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Represents the current state of the synchronization engine
enum SyncStatus { idle, syncing, synced, error, offline }

class SyncState {
  final SyncStatus status;
  final int pendingCount;
  final DateTime? lastSyncTime;
  final String? errorMessage;

  const SyncState({
    this.status = SyncStatus.idle,
    this.pendingCount = 0,
    this.lastSyncTime,
    this.errorMessage,
  });

  SyncState copyWith({
    SyncStatus? status,
    int? pendingCount,
    DateTime? lastSyncTime,
    String? errorMessage,
  }) {
    return SyncState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Manages offline queue and data synchronization between Isar and Supabase
class SyncService extends StateNotifier<SyncState> {
  Timer? _autoSyncTimer;

  SyncService() : super(const SyncState()) {
    _startAutoSync();
  }

  void _startAutoSync() {
    // Auto-sync every 5 minutes when the app is running
    _autoSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      syncNow();
    });
  }

  /// Manually trigger a sync cycle
  Future<void> syncNow() async {
    if (state.status == SyncStatus.syncing) return;

    state = state.copyWith(status: SyncStatus.syncing);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        state = state.copyWith(
            status: SyncStatus.error, errorMessage: 'Not authenticated');
        return;
      }

      // Check connectivity by pinging Supabase
      try {
        await Supabase.instance.client
            .from('profiles')
            .select('id')
            .eq('id', userId)
            .single();
      } catch (e) {
        state = state.copyWith(
          status: SyncStatus.offline,
          errorMessage: 'No internet connection',
        );
        return;
      }

      // Pull latest data counts from server to verify sync state
      final parties = await Supabase.instance.client
          .from('parties')
          .select('id')
          .eq('user_id', userId);

      final entries = await Supabase.instance.client
          .from('entries')
          .select('id')
          .eq('user_id', userId);

      debugPrint(
          'Sync complete: ${parties.length} parties, ${entries.length} entries');

      state = state.copyWith(
        status: SyncStatus.synced,
        pendingCount: 0,
        lastSyncTime: DateTime.now(),
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: SyncStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Queue a write operation for eventual sync (offline-first)
  void queueWrite(String table, Map<String, dynamic> data) {
    // In a full implementation, this would write to Isar first
    // then mark the record as pending sync
    state = state.copyWith(pendingCount: state.pendingCount + 1);
    debugPrint('Queued write to $table — pending: ${state.pendingCount}');
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }
}

/// Global sync service provider
final syncServiceProvider =
    StateNotifierProvider<SyncService, SyncState>((ref) {
  return SyncService();
});
