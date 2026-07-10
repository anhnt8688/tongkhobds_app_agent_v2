import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../data/models/chat_room.dart';
import 'controllers/chat_room_controller.dart';
import 'controllers/inbox_controller.dart';
import 'widgets/conversation_tile.dart';

/// Inbox with two tabs — "Tư vấn" (support) and "Giao dịch" (transactions) —
/// listing conversations with realtime unread badges (matches v1 AllMessage).
class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});
  @override
  ConsumerState<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends ConsumerState<InboxScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this)
    ..addListener(() {
      if (!_tab.indexIsChanging) {
        ref.read(inboxControllerProvider.notifier).setTab(_tab.index);
      }
    });

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inboxControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Tin nhắn'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.text,
          labelStyle: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          tabs: const [Tab(text: 'Tư vấn'), Tab(text: 'Giao dịch')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _RoomList(rooms: state.consult, state: state),
          _RoomList(rooms: state.transaction, state: state),
        ],
      ),
    );
  }
}

class _RoomList extends ConsumerWidget {
  const _RoomList({required this.rooms, required this.state});
  final List<ChatRoom> rooms;
  final InboxState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = ref.read(inboxControllerProvider.notifier);

    if (state.loading && rooms.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && rooms.isEmpty) {
      return _centered('Không tải được tin nhắn', onRetry: ctl.refresh);
    }
    return RefreshIndicator(
      onRefresh: ctl.refresh,
      child: rooms.isEmpty
          ? ListView(children: [_centered('Chưa có tin nhắn')])
          : ListView.separated(
              itemCount: rooms.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.border),
              itemBuilder: (_, i) {
                final room = rooms[i];
                return ConversationTile(
                  room: room,
                  onTap: () => _open(context, ref, room),
                );
              },
            ),
    );
  }

  Future<void> _open(BuildContext context, WidgetRef ref, ChatRoom room) async {
    final id = room.roomId;
    final ctl = ref.read(inboxControllerProvider.notifier);
    ctl.enter(id);
    await context.push('/chat',
        extra: ChatRoomArgs(
          roomId: id,
          name: room.name,
          botId: room.botId,
          projectId: room.projectIdInt,
          initialContent: room.messageContent,
        ));
    ctl.leave(id);
  }

  Widget _centered(String text, {VoidCallback? onRetry}) => Padding(
        padding: const EdgeInsets.only(top: 120),
        child: Column(
          children: [
            Text(text, style: AppTypography.body.copyWith(color: AppColors.textMute)),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      );
}
