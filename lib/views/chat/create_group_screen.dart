import 'package:chatting/views/widgets/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:chatting/models/users_model.dart';

class CreateGroupScreen extends StatefulWidget {
  final List<Users> users;

  const CreateGroupScreen({super.key, required this.users});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  List<Users> selectedUsers = [];
  TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed:
                selectedUsers.isNotEmpty && groupNameController.text.isNotEmpty
                    ? createGroup
                    : null,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFieldCustom(
              controller: groupNameController,
              hintText: "Group Name",
              inputType: TextInputType.text,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                final user = widget.users[index];
                final isSelected = selectedUsers.contains(user);
                return ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.urlAvatar)),
                  title: Text(user.name),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      isSelected
                          ? selectedUsers.remove(user)
                          : selectedUsers.add(user);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void createGroup() {
    String groupName = groupNameController.text.trim();
    print(
        "Tạo nhóm '$groupName' với: ${selectedUsers.map((e) => e.name).join(", ")}");

    Navigator.pop(context);
  }
}
