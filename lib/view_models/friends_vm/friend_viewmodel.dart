import 'package:chatting/models/users_model.dart';
import 'package:chatting/services/store_services.dart';
import 'package:chatting/view_models/profile_vm/profile_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendViewModel {
  // khai báo tài nguyên
  final ProfileViewModel profile = ProfileViewModel();
  final StoreServices store = StoreServices();
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Lấy uid bạn bè
  Future<List<Users>?> getFriend() async {
    try {
      Users? users = await profile.getUserProfile();
      if (users?.friends == null || users!.friends!.isEmpty) return null;
      List<Users?> listUserFriend = await Future.wait(
          users.friends!.map((uid) async => await store.getUserInfo(uid: uid)));
      return listUserFriend.whereType<Users>().toList();
    } catch (e) {
      rethrow;
    }
  }

  // Lấy uid bạn bè yêu cầu
  Future<List<String>?> getFriendRequest() async {
    try {
      Users? users = await profile.getUserProfile();
      return users?.friendRequests ?? [];
    } catch (e) {
      rethrow;
    }
  }

  // hiển thị tìm kiếm bạn bè
  Future<Users?> findFriends({required String uid}) async {
    try {
      if (auth.currentUser?.uid == uid) return null;
      return await store.getUserInfo(uid: uid);
    } catch (e) {
      rethrow;
    }
  }

  // add friends
  Future<bool> sendFriend({required String receiverUid}) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null || receiverUid == currentUser.uid) return false;
      Users? user = await findFriends(uid: receiverUid);
      if (user?.friendRequests?.contains(currentUser.uid) ?? false) {
        return false;
      }
      await store.sendFriendRequest(receiverUid);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  // Kiểm tra xem UID có trong danh sách yêu cầu kết bạn không
  Future<bool> checkFriends({required String uid}) async {
    bool isCheckFriend = false;
    Users? friend = await findFriends(uid: uid);
    if (friend != null && friend.friendRequests != null) {
      if (friend.friendRequests!.contains(auth.currentUser!.uid)) {
        isCheckFriend = true;
      }
    }

    Users? user = await profile.getUserProfile();
    if (user != null && user.friends != null) {
      if (user.friends!.contains(uid)) isCheckFriend = true;
    }
    return isCheckFriend;
  }
}
