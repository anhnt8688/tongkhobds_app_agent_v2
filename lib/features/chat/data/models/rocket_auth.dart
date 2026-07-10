/// RocketChat credentials (v1 RocketChatModel), obtained from the app backend
/// `refresh_token_rocket.json` and used for REST headers + DDP login.
class RocketAuth {
  const RocketAuth({this.token, this.userId, this.username, this.groupSupportId});

  final String? token;
  final String? userId;
  final String? username;
  final String? groupSupportId;

  bool get isValid => (token ?? '').isNotEmpty && (userId ?? '').isNotEmpty;

  factory RocketAuth.fromJson(Map d) => RocketAuth(
        token: d['token']?.toString(),
        userId: d['user_id']?.toString(),
        username: d['user_name']?.toString(),
        groupSupportId: d['group_support_id']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'user_id': userId,
        'user_name': username,
        'group_support_id': groupSupportId,
      };
}
