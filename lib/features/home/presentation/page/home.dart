import 'package:flutter/material.dart';
import 'package:template_flutter/core/components/selectable_list_grid.dart';
import 'package:template_flutter/features/auth/domain/entities/user.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = List.generate(
      20,
      (i) => User(name: "Usuario $i", email: "usuario@gamail.com"),
    );

    return SelectableListGrid<User>(
      items: users,
      title: "Usuarios",
      itemBuilder: (user, isSelected) {
        return ListTile(
          title: Text(user.name),
          tileColor: isSelected ? Colors.blue.shade100 : null,
        );
      },
    );
  }
}
