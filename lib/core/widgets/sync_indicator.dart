import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/sync_service.dart';
import '../../app/theme.dart';

/// A compact sync status indicator widget to be placed in AppBars or headers.
/// Shows real-time sync state with color-coded icons and tap-to-sync.
class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncServiceProvider);

    IconData icon;
    Color color;
    String tooltip;

    switch (syncState.status) {
      case SyncStatus.idle:
        icon = Icons.cloud_outlined;
        color = Colors.white70;
        tooltip = 'Tap to sync';
        break;
      case SyncStatus.syncing:
        icon = Icons.cloud_sync;
        color = AppTheme.warningOrange;
        tooltip = 'Syncing...';
        break;
      case SyncStatus.synced:
        icon = Icons.cloud_done;
        color = AppTheme.successGreen;
        tooltip = 'All data synced';
        break;
      case SyncStatus.error:
        icon = Icons.cloud_off;
        color = AppTheme.dangerRed;
        tooltip = syncState.errorMessage ?? 'Sync error';
        break;
      case SyncStatus.offline:
        icon = Icons.wifi_off;
        color = Colors.grey;
        tooltip = 'Offline — data saved locally';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          ref.read(syncServiceProvider.notifier).syncNow();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(tooltip),
                  if (syncState.pendingCount > 0) ...[
                    const SizedBox(width: 8),
                    Text('(${syncState.pendingCount} pending)',
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ],
              ),
              backgroundColor: AppTheme.primaryBlue,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: syncState.status == SyncStatus.syncing
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: color,
                    strokeWidth: 2,
                  ),
                )
              : Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}
