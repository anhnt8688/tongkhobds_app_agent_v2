import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'controllers/chat_room_controller.dart';

/// A single chat room thread. Uses flutter_chat_ui for the message list +
/// composer, backed by [ChatRoomController] (history, realtime, optimistic send).
class ChatRoomScreen extends ConsumerWidget {
  const ChatRoomScreen({super.key, required this.args});
  final ChatRoomArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatRoomControllerProvider(args));
    final ctl = ref.read(chatRoomControllerProvider(args).notifier);
    final title = args.name?.isNotEmpty == true ? args.name! : 'Tin nhắn';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: state.error != null
          ? _error(state.error!)
          : state.loading
              ? const Center(child: CircularProgressIndicator())
              : Chat(
                  currentUserId: ctl.myUserId,
                  chatController: ctl.chatController,
                  resolveUser: (id) => _resolveUser(id, ctl.myUserId),
                  onMessageSend: ctl.send,
                  onAttachmentTap: () => _pickFile(ctl),
                  onMessageTap: (context, message, {required index, required details}) {
                    if (message is TextMessage &&
                        message.status == MessageStatus.error) {
                      ctl.retry(message);
                    }
                  },
                ),
    );
  }

  /// Others show the room name + avatar; self is a minimal user.
  Future<User?> _resolveUser(String id, String myId) async {
    if (id == myId) return User(id: id, name: 'Bạn');
    return User(id: id, name: args.name);
  }

  Future<void> _pickFile(ChatRoomController ctl) async {
    final res = await FilePicker.platform.pickFiles();
    final file = res?.files.single;
    if (file?.path != null) {
      await ctl.sendFile(file!.path!, file.name);
    }
  }

  Widget _error(String msg) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(msg,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.textMute)),
        ),
      );
}
