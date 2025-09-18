import 'package:flutter/material.dart';
import 'package:template_flutter/core/components/generic_page.dart';
import 'package:template_flutter/core/components/image_picker_field.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/base_controller.dart';
import 'package:template_flutter/features/auth/domain/entities/user.dart';
import 'package:template_flutter/features/auth/infraestructure/usuario_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imageBase64 = '';

  final List<User> users = List.generate(
    10,
    (i) => User(
      name: "Usuario $i",
      email: "usuario$i@gmail.com",
      photoProfile: "https://picsum.photos/id/$i/200/300",
      id: i,
    ),
  );

  final BaseController<User> controller = UsuarioController();

  @override
  Widget build(BuildContext context) {
    return GenericPage<User>(
      title: "Usuarios",
      controller: controller,
      items: users,
      formBuilder: (context, user, onChanged) {
        final nameController = TextEditingController(text: user.name);
        final emailController = TextEditingController(text: user.email);

        return Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => onChanged(user..name = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => onChanged(user..email = v),
            ),
            const SizedBox(height: 12),
            ImagePickerField(
              initialBase64: imageBase64,
              onChanged: (v) => onChanged(user..photoProfile = v),
            ),
          ],
        );
      },
      itemBuilder: (user, isSelected) {
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          selected: isSelected,
        );
      },
    );
  }
}
