import 'package:flutter/material.dart';
import 'package:stylle/components/column_field.dart';
import 'package:stylle/services/collections/my_users.dart';

import 'yes_no_dialog.dart';

class UsersTable extends StatelessWidget {
  const UsersTable({
    super.key, required this.users,
  });

  final List<MyUser> users;

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          horizontalMargin: 10,
          columnSpacing: 20,
          dataRowMinHeight: 50,
          dataRowMaxHeight: 60,
          border: TableBorder.all(width: 0.3, color: Colors.black26),
          headingRowColor: MaterialStateColor.resolveWith(
              (states) => Colors.black),
          headingRowHeight: 50,
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: ColumnField(name: "ID")),
            DataColumn(label: ColumnField(name: "Profile")),
            DataColumn(label: ColumnField(name: "Name")),
            DataColumn(label: ColumnField(name: "Email")),
            DataColumn(label: ColumnField(name: "Delete")),
          ],
          rows: [
            for (var i = 0; i < users.length; i++)
              myRow(context, users[i], i + 1),
          ]),
    );
  }

  DataRow myRow(
    BuildContext context,
    MyUser item,
    int order,
  ) {
    return DataRow(
        cells: [
          DataCell(
            Center(
              child: Text(
                order.toString(),
              ),
            ),
          ),
          DataCell(
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                height: 40,
                width: 40,
                child: Image(
                  image: NetworkImage(
                    item.profileImage.isNotEmpty ? 
                      item.profileImage : 
                      'https://static.vecteezy.com/system/resources/previews/024/983/914/original/simple-user-default-icon-free-png.png',
                  ),
                ),
              ),
            )
          ),
          DataCell(
            Text(
              item.getName,
            ),
          ),
          DataCell(
            Text(
              item.email,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          DataCell(
            Center(
              child: !item.deleted
                ? InkWell(
                    onTap: () {
                      _delete(context, item);
                    },
                    child: Container(
                      height: 45,
                      constraints: const BoxConstraints(minWidth: 200),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      _restore(context, item);
                    },
                    child: Container(
                      height: 45,
                      constraints: const BoxConstraints(minWidth: 200),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.restore,
                        color: Colors.green,
                      ),
                    ),
                  )
              )),
        ]);
  }

  /// Show dialog confirm delete service
  void _delete(
    BuildContext context,
    MyUser item,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Delete this user",
          content:
              "Are your sure you want to delete this user?",
        );
      },
    ).then((value) {
      if (value ?? false) {
        item.update({'deleted': true});
      }
    });
  }

  /// Show dialog confirm restore service
  void _restore(
    BuildContext context,
    MyUser item,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Restore deleted user",
          content: "Are you sure you want to restore this user?",
        );
      },
    ).then((value) {
      if (value  ?? false) {
        item.update({'deleted': false});
      }
    });
  }
}
