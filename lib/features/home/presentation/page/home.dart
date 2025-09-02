import 'package:flutter/material.dart';
import 'package:template_flutter/core/components/selectable_list_grid.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/base_controller.dart';
import 'package:template_flutter/features/auth/domain/entities/user.dart';
import 'package:template_flutter/features/auth/infraestructure/usuario_controller.dart';
import 'package:template_flutter/core/components/action_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<User> users = List.generate(
    10,
    (i) => User(
      name: "Usuario $i",
      email: "usuario$i@gmail.com",
      id: i,
    ),
  );

  List<User> selectedUsers = [];
  late final BaseController<User> controller;

  // 🔹 Controladores para el formulario superior
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // 🔹 Usuario en edición
  User? editingUser;

  @override
  void initState() {
    super.initState();
    controller = UsuarioController();
  }

  void startEditing(User user) {
    setState(() {
      editingUser = user;
      nameController.text = user.name;
      emailController.text = user.email;
    });
  }

  void saveEditing() {
    if (editingUser != null) {
      setState(() {
        editingUser!.name = nameController.text;
        editingUser!.email = emailController.text;
        editingUser = null; // cerrar edición
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuarios")),
      body: Column(
        children: [
          // 🔹 Formulario superior (solo visible si hay usuario en edición)
          if (editingUser != null)
            Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    ActionButtons<User>(
                      controller: controller,
                      item: editingUser!,
                      itemId: editingUser!.id?.toString(),
                      onReset: (nuevo) {
                        setState(() {
                          startEditing(nuevo);
                          editingUser = null; // cerrar edición
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

          // 🔹 Lista de usuarios
          Expanded(
            child: SelectableListGrid<User>(
              items: users,
              title: "Usuarios",
              onSelectionChange: (selection) {
                setState(() => selectedUsers = selection);
              },
              itemBuilder: (user, isSelected) {
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  selected: isSelected,
                );
              },
              onEdit: (user) => {startEditing(user)},
              onDelete: (user) {
                setState(() {
                  users.remove(user);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Eliminado: ${user.name}")),
                );
              },
            ),
          ),

          if (selectedUsers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Seleccionados: ${selectedUsers.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
