import 'package:flutter/material.dart';
import 'package:template_flutter/core/components/generic_page.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/base_controller.dart';
import 'package:template_flutter/features/auth/domain/entities/user.dart';
import 'package:template_flutter/features/auth/infraestructure/usuario_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<User> users = List.generate(
    10,
    (i) => User(
      name: "Usuario $i",
      email: "usuario$i@gmail.com",
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
      // 🔹 Formulario personalizable
      formBuilder: (context, user, onChanged) {
        final nameController = TextEditingController(text: user?.name ?? '');
        final emailController = TextEditingController(text: user?.email ?? '');
        return Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => onChanged(user!..name = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => onChanged(user!..email = v),
            ),
          ],
        );
      },
      // 🔹 Cómo se ve cada item en la lista
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
