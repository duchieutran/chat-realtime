// import 'package:chatting/models/users_model.dart';
// import 'package:flutter/material.dart';
//
// class InfoGroupScreen extends StatefulWidget {
//   const InfoGroupScreen({super.key});
//
//   @override
//   State<InfoGroupScreen> createState() => _InfoGroupScreenState();
// }
//
// class _InfoGroupScreenState extends State<InfoGroupScreen> {
//   List<Users> users = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Select Members",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//           const SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.users.length,
//               itemBuilder: (context, index) {
//                 final user = widget.users[index];
//                 final isSelected = selectedUsers.contains(user);
//
//                 return GestureDetector(
//                   onTap: () => setState(() => isSelected
//                       ? selectedUsers.remove(user)
//                       : selectedUsers.add(user)),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 400),
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: isSelected
//                                 ? AppColors.blue40.withOpacity(0.6)
//                                 : Colors.grey.withOpacity(0.4),
//                             blurRadius: 10,
//                             spreadRadius: 2,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 20, vertical: 10),
//                         leading: CircleAvatar(
//                           radius: 28,
//                           backgroundImage: NetworkImage(user.urlAvatar),
//                         ),
//                         title: Text(user.name,
//                             style: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.w600)),
//                         trailing: AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 300),
//                           child: isSelected
//                               ? const Icon(Icons.check_circle,
//                               color: Colors.green, size: 28)
//                               : const SizedBox.shrink(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
