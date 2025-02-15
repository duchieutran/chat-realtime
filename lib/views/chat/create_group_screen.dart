import 'package:chatting/models/users_model.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/message_vm.dart';
import 'package:chatting/views/widgets/text_field_custom.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  final List<Users> users;

  const CreateGroupScreen({super.key, required this.users});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  int chooseImg = 0;
  final List<String> avatarGroup = [group, group_1, group_2, group_3];
  final List<Users> selectedUsers = [];
  final MessageViewModel messageViewModel = MessageViewModel();
  late TextEditingController groupNameController;

  @override
  void initState() {
    super.initState();
    groupNameController = TextEditingController();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        title: const Text("Create Group",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildAvatarSelection(),
            const SizedBox(height: 20),
            _buildGroupNameField(),
            const SizedBox(height: 20),
            _buildMemberSelection(),
            const SizedBox(height: 20),
            _buildCreateButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Group Avatar",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: avatarGroup.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() => chooseImg = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: chooseImg == index
                          ? AppColors.blue70
                          : Colors.transparent,
                      width: 3,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: chooseImg == index ? 40 : 30,
                    backgroundImage: NetworkImage(avatarGroup[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupNameField() {
    return TextFieldCustom(
      controller: groupNameController,
      onChanged: (value) => setState(() {}),
      hintText: "Group Name",
      inputType: TextInputType.text,
    );
  }

  Widget _buildMemberSelection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Members",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                final user = widget.users[index];
                final isSelected = selectedUsers.contains(user);

                return GestureDetector(
                  onTap: () => setState(() => isSelected
                      ? selectedUsers.remove(user)
                      : selectedUsers.add(user)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? AppColors.blue40.withOpacity(0.6)
                                : Colors.grey.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(user.urlAvatar),
                        ),
                        title: Text(user.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        trailing: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green, size: 28)
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    final bool isEnabled =
        selectedUsers.length >= 2 && groupNameController.text.isNotEmpty;

    return Center(
      child: ElevatedButton.icon(
        onPressed: isEnabled ? createGroup : null,
        icon: const Icon(Icons.group_add, color: AppColors.light),
        label: const Text("Create Group",
            style: TextStyle(color: AppColors.light)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          backgroundColor: isEnabled ? AppColors.blue40 : Colors.grey[400],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Future<void> createGroup() async {
    messageViewModel.createChatRoomGroup(
      urlAvatar: avatarGroup[chooseImg],
      name: groupNameController.text.trim(),
      members: selectedUsers.map((e) => e.uid).toList(),
    );
    Navigator.pop(context);
  }
}
