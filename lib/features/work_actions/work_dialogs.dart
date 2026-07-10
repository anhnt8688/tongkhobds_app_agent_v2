/// Shared rich work-action dialogs for nhu-cầu-mua and nhu-cầu-bán.
/// All dialogs return typed records (or `null` when cancelled); the caller
/// posts the result via the feature's `work_consultation` client.
library;

export 'work_appointment_dialog.dart';
export 'work_call_dialog.dart';
export 'work_deposit_dialog.dart';
export 'work_dialog_kit.dart' show WorkDialogContext;
export 'work_note_dialog.dart';
export 'work_send_dialog.dart';
export 'work_verify_dialog.dart';
