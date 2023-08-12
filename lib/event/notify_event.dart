class NKey {
  static const String token_invalid = "Token_Invalid";
  static const String refresh_chat = "Refresh_Chat";
  static const String refresh_chat_detail = "Refresh_Chat_Detail";
  static const String refresh_note_name = "Refresh_NoteName";
  static const String refresh_corner = "Refresh_Corner";
  static const String refresh_contact = "Refresh_Contact";
  static const String refresh_user_info = "Refresh_User_Info";
  static const String leave_group = "Leave_Group";
  static const String Dissolve_Group = "dissolve_group";
  static const String NavigatorIndex = "navigator_index";
}

class NotifyEvent {
  final String msg;
  final dynamic arg;

  NotifyEvent({required this.msg, this.arg});
}