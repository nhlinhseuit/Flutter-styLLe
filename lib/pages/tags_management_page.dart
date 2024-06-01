import 'package:flutter/material.dart';
import 'package:stylle/components/tags_table.dart';
import 'package:stylle/components/update_tag_dialog.dart';
import 'package:stylle/constants/routes.dart';
import 'package:stylle/services/auth/auth_service.dart';
import 'package:stylle/services/collections/image_tag.dart';
import 'package:stylle/services/collections/image_tag_service.dart';
import 'package:stylle/utilities/popup_confirm_dialog.dart';

class TagManagementPage extends StatefulWidget {
  const TagManagementPage({super.key});

  @override
  State<TagManagementPage> createState() => _TagManagementPageState();
}

class _TagManagementPageState extends State<TagManagementPage> {
  final service = ImageTagService();
  @override
  Widget build(BuildContext context) {
    var tagStream = service.tagStream();

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
            stream: tagStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tags = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.sizeOf(context).width,
                            ),
                            child: ImageTagsTable(tags: tags,)
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildAddPlace(tags),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  
  Widget _buildAddPlace(List<ImageTag> tags) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).padding.bottom + 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
          foregroundColor: Colors.black
        ),
        onPressed: () async {
          final data = await showDialog(
            context: context,
            builder: (context) {
              return UpdateTagDialog(
                list: tags,
              );
            },
          );
          if (data != null && data is ImageTag) {
            final added = data;
            debugPrint("$added");
            final success = await ImageTagService().addTag(added);
            if (success) {
              // Navigator.of(context).pop();
            } 
          }
        },
        child: const Text(
          "Add New",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
