import 'package:chatting/models/users_model.dart';
import 'package:chatting/utils/app_colors.dart';
import 'package:chatting/utils/app_routers.dart';
import 'package:chatting/utils/assets.dart';
import 'package:chatting/view_models/message_vm.dart';
import 'package:chatting/views/widgets/app_loading.dart';
import 'package:chatting/views/widgets/text_field_custom.dart';
import 'package:flutter/material.dart';

class UpdateGroup extends StatefulWidget {
  final List<Users> users;
  final bool isUpdate;
  final String groupName;
  final String uidGroup;
  final List<Users>? usersInGroup;

  const UpdateGroup(
      {super.key,
      required this.users,
      this.isUpdate = false,
      this.groupName = '',
      this.uidGroup = '',
      this.usersInGroup});

  @override
  State<UpdateGroup> createState() => _UpdateGroupState();
}

class _UpdateGroupState extends State<UpdateGroup> {
  int chooseImg = 0;
  final List<String> avatarGroup = [group, group_1, group_2, group_3];
  late List<Users> selectedUsers;
  final MessageViewModel messageViewModel = MessageViewModel();
  late TextEditingController groupNameController;

  @override
  void initState() {
    super.initState();
    selectedUsers = widget.isUpdate
        ? ((widget.usersInGroup != null) ? widget.usersInGroup! : [])
        : [];
    groupNameController = widget.isUpdate
        ? TextEditingController(text: widget.groupName)
        : TextEditingController();
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
        title: Text(widget.isUpdate ? "Update Group" : "Create Group",
            style: const TextStyle(fontWeight: FontWeight.bold)),
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
          Text(widget.isUpdate ? "Add Members" : "Select Members",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                final user = widget.users[index];
                bool isSelected = false;
                if (selectedUsers.isNotEmpty) {
                  for (int i = 0; i < selectedUsers.length; i++) {
                    if (selectedUsers[i].uid == user.uid) {
                      isSelected = true;
                      break;
                    }
                  }
                }
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
    final bool isEnabled = selectedUsers.length >= (widget.isUpdate ? 1 : 2) &&
        groupNameController.text.isNotEmpty;

    return Center(
      child: ElevatedButton.icon(
        onPressed:
            isEnabled ? (widget.isUpdate ? updateGroup : createGroup) : null,
        icon: Icon(widget.isUpdate ? Icons.upcoming_sharp : Icons.group_add,
            color: AppColors.light),
        label: Text(widget.isUpdate ? "Update Group" : "Create Group",
            style: const TextStyle(color: AppColors.light)),
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
    appLoading(context: context, gif: gifLoading);
    messageViewModel.createChatRoomGroup(
      urlAvatar: avatarGroup[chooseImg],
      name: groupNameController.text.trim(),
      members: selectedUsers.map((e) => e.uid).toList(),
    );
    Navigator.pop(context);
    Navigator.popAndPushNamed(context, AppRouters.chat);
  }

  Future<void> updateGroup() async {
    appLoading(context: context, gif: gifLoading);
    messageViewModel.updateChatRoomGroup(
        uidGroup: widget.uidGroup,
        urlAvatar: avatarGroup[chooseImg],
        name: groupNameController.text.trim(),
        members: selectedUsers.map((e) => e.uid).toList());
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
