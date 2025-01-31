import 'package:chatting/models/users.dart';
import 'package:chatting/view_models/profile/profile_viewmodel.dart';

class FriendViewModel {
  // khai báo tài nguyên
  final ProfileViewModel profile = ProfileViewModel();

  // Lấy uid bạn bè
  Future<List<String>?> getFriend() async {
    try {
      Users? users = await profile.getUserProfile();
      if (users != null) {
        List<String>? listFriend = users.friends;
        return listFriend ?? [];
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // Lấy uid bạn bè yêu cầu
  Future<List<String>?> getFriendRequest() async {
    try {
      Users? users = await profile.getUserProfile();
      if (users != null) {
        List<String>? listFriend = users.friendRequests;
        return listFriend ?? [];
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
