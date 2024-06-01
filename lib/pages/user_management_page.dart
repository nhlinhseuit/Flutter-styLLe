import 'package:flutter/material.dart';
import 'package:stylle/components/users_table.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/collections/my_users.dart';
import 'package:stylle/utilities/popup_confirm_dialog.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  @override
  Widget build(BuildContext context) {
    var userStream = MyUser.readUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tag management page'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () async {
              final confirmLogout = await showLogOutDialog(context,
                  content: 'Logging out?', title: 'Log out');

              if (confirmLogout) {
                await AuthService.firebase().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (_) => false,
                );
              }
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black.withAlpha(100),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: StreamBuilder(
            stream: userStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final users = snapshot.data!;
                return Container(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.sizeOf(context).width,
                      ),
                      child: UsersTable(users: users,)
                    );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text('Error: ${snapshot.error}');
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
