import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatefulWidget {
  final void Function(String) onChanged; // Devuelve la imagen seleccionada
  final double radius;
  final String? initialBase64; // Opcional, si ya hay imagen inicial

  const ImagePickerField({
    super.key,
    required this.onChanged,
    this.radius = 30,
    this.initialBase64,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  String? pathBase64;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    pathBase64 = widget.initialBase64;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        pathBase64 = base64String;
      });

      widget.onChanged(base64String); // Devuelve el valor al formulario
    }
  }

  ImageProvider _getImage() {
    if (pathBase64 != null && pathBase64!.isNotEmpty) {
      return MemoryImage(base64Decode(pathBase64!));
    }
    return const AssetImage('images/default_avatar.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: widget.radius,
          backgroundImage: _getImage(),
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.photo),
          label: const Text("Seleccionar Imagen"),
        ),
      ],
    );
  }
}
