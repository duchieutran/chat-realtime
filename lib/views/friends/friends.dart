import 'package:chatting/view_models/friends_vm/friend_viewmodel.dart';
import 'package:chatting/views/friends/component/card_info.dart';
import 'package:flutter/material.dart';
import 'package:chatting/models/users.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final FriendViewModel friendVM = FriendViewModel();
  final TextEditingController searchController = TextEditingController();
  Users? searchedUser;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Friends",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Friends"),
              Tab(text: "Requests"),
              Tab(text: "Search"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFriendsList(size: size),
            _buildFriendRequests(),
            _buildSearchFriends(),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsList({required Size size}) {
    return FutureBuilder<List<Users>?>(
      future: friendVM.getFriend(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Center(child: Text("No friends"));
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            Users user = snapshot.data![index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: CardInfo(
                function: () {
                  print("not null");
                },
                urlAvatar: user.urlAvatar,
                email: user.email,
                name: user.name,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFriendRequests() {
    return FutureBuilder<List<String>?>(
      future: friendVM.getFriendRequest(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return const Center(child: Text("No requests"));
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ListTile(
                title: Text("UID: ${snapshot.data![index]}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Handle accept request
                  },
                  child: const Text("Accept"),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchFriends() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: "Enter UID",
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  String uid = searchController.text.trim();
                  if (uid.isNotEmpty) {
                    Users? user = await friendVM.findFriends(uid: uid);
                    setState(() => searchedUser = user);
                  }
                },
              ),
            ),
          ),
        ),
        if (searchedUser != null)
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(searchedUser!.urlAvatar ??
                    "https://via.placeholder.com/150"),
              ),
              title: Text(searchedUser!.name ?? "No name",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(searchedUser!.email ?? "No email"),
              trailing: ElevatedButton(
                onPressed: () async {
                  bool success =
                      await friendVM.sendFriend(receiverUid: searchedUser!.uid);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Request sent")),
                    );
                  }
                },
                child: const Text("Add friend"),
              ),
            ),
          ),
      ],
    );
  }
}
