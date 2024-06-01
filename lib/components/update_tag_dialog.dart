import 'package:flutter/material.dart';
import 'package:stylle/services/collections/image_tag.dart';

import 'keyboard_dismiss.dart';

class UpdateTagDialog extends StatefulWidget {
  const UpdateTagDialog({
    super.key,
    this.item,
    required this.list,
  });

  final List<ImageTag> list;
  final ImageTag? item;

  @override
  State<UpdateTagDialog> createState() => _UpdateTagDialogState();
}

class _UpdateTagDialogState extends State<UpdateTagDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _nameFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  String? errorName;
  String? errorDescription;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.item?.name ?? "";
    _descriptionController.text = widget.item?.description ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();

    _nameFocus.dispose();
    _descriptionFocus.dispose();

    super.dispose();
  }

  _submit() {
    String name = _nameController.text.trim();
    String description = _descriptionController.text.trim();

    if (name.isEmpty) {
      setState(() {
        errorName = "The name of this tag cannot be empty";
      });
      return;
    }
    if (description.isEmpty) {
      setState(() {
        errorDescription = "The description of this tag cannot be empty!";
      });
      return;
    }

    ImageTag updated;
    if (widget.item != null) {
      updated = widget.item!.copyWith(
        name: name,
        description: description,
      );
    } else {
      updated = ImageTag(
        id: "",
        name: name, 
        description: description, deleted: false,
      );
    }

    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 12),
        // padding: const EdgeInsets.only(top: 10),
        child: Material(
          color: Colors.transparent,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(maxWidth: 600),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocus,
                            autofocus: true,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Enter name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _nameController.text = "";
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.clear,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              errorText: errorName,
                            ),
                            onChanged: (value) {
                              if (value.trim().isNotEmpty &&
                                  errorName != null) {
                                setState(() {
                                  errorName = null;
                                });
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              _descriptionFocus.nextFocus();
                            },
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            maxLength: 50,
                          ),
                          const SizedBox(height: 15),
                          
                          const Text(
                            "Description",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _descriptionController,
                            focusNode: _descriptionFocus,
                            autofocus: true,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Enter description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _descriptionController.text = "";
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.clear,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              errorText: errorDescription,
                            ),
                            onChanged: (value) {
                              if (value.trim().isNotEmpty &&
                                  errorDescription != null) {
                                setState(() {
                                  errorDescription = null;
                                });
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              _submit();
                            },
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              fixedSize:
                                  Size(MediaQuery.sizeOf(context).width, 50),
                            ),
                            child: const Text(
                              "SAVE",
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.clear,
                          size: 30,
                        ),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
