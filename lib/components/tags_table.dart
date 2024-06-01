import 'package:flutter/material.dart';
import 'package:stylle/components/column_field.dart';
import 'package:stylle/components/update_tag_dialog.dart';
import 'package:stylle/services/collections/image_tag.dart';
import 'package:stylle/services/collections/image_tag_service.dart';

import 'yes_no_dialog.dart';

class ImageTagsTable extends StatelessWidget {
  ImageTagsTable({
    super.key, required this.tags,
  });

  final List<ImageTag> tags;

  final tagService = ImageTagService();

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          horizontalMargin: 10,
          columnSpacing: 20,
          dataRowMinHeight: 45,
          dataRowMaxHeight: 45,
          border: TableBorder.all(width: 0.3, color: Colors.black26),
          headingRowColor: MaterialStateColor.resolveWith(
              (states) => Colors.black),
          headingRowHeight: 50,
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: ColumnField(name: "ID")),
            DataColumn(label: ColumnField(name: "Name")),
            DataColumn(label: ColumnField(name: "Description")),
            DataColumn(label: ColumnField(name: "Delete")),
          ],
          rows: [
            for (var i = 0; i < tags.length; i++)
              myRow(context, tags[i], i + 1),
          ]),
    );
  }

  DataRow myRow(
    BuildContext context,
    ImageTag item,
    int order,
  ) {
    return DataRow(
        onSelectChanged: (value) {
          if (value == true) {
            _update(context, item);
          }
        },
        cells: [
          DataCell(
            Center(
              child: Text(
                order.toString(),
              ),
            ),
          ),
          DataCell(
            Text(
              item.name,
            ),
          ),
          DataCell(
            Text(
              item.description,
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
                        Icons.delete_outline,
                        color: Colors.green,
                      ),
                    ),
                  )
              )),
        ]);
  }

  /// Show dialog update service
  void _update(
    BuildContext context,
    ImageTag item,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateTagDialog(
          item: item,
          list: tags,
        );
      },
    ).then((data) {
      if (data != null && data is ImageTag) {
        final updated = data;
        tagService.updateTag(updated);
      }
    });
  }

  /// Show dialog confirm delete service
  void _delete(
    BuildContext context,
    ImageTag item,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Delete this item",
          content:
              "Are your sure you want to delete this item?\nDeleted items cannot be used for other related features.",
        );
      },
    ).then((value) {
      if (value ?? false) {
        tagService.deleteTag(item);
      }
    });
  }

  /// Show dialog confirm restore service
  void _restore(
    BuildContext context,
    ImageTag item,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Restore deleted item",
          content: "Are you sure you want to restore this item?",
        );
      },
    ).then((value) {
      if (value) {
        tagService.updateTag(item, updateData: {'deleted': false});
      }
    });
  }
}
