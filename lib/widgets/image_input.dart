import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelectImage});

  final void Function(File image) onSelectImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;

  void takePicture(String source) async {
    final imagePicker = ImagePicker();
    XFile? pickedImage;

    if (source == "camera") {
      pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    } else {
      pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    }

    if (pickedImage == null) {
      return;
    }

    setState(() {
      selectedImage = File(pickedImage!.path);
      widget.onSelectImage(selectedImage!);
    });
  }

  void resetImage() {
    setState(() {
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.camera),
            label: const Text("Take Picture"),
            onPressed: () {
              takePicture("camera");
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.browse_gallery),
            label: const Text("Choose Picture"),
            onPressed: () {
              takePicture("galery");
            },
          ),
        ],
      ),
    );

    if (selectedImage != null) {
      content = GestureDetector(
        onTap: resetImage,
        child: Image.file(
          selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            5,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}
