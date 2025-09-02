// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/base_controller.dart';
import 'package:template_flutter/core/shared/http/domain/base_entity.dart';

class ActionButtons<T extends BaseEntity> extends StatelessWidget {
  final BaseController<T> controller;
  final T item;
  final String? itemId; // null = crear, no-null = actualizar
  final void Function(T newItem)? onReset;

  const ActionButtons({
    super.key,
    required this.controller,
    required this.item,
    this.itemId,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isNew = itemId == null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Guardar o Actualizar
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isNew ? Colors.green : Colors.orange,
          ),
          onPressed: () async {
            try {
              if (isNew) {
                await controller.guardar(item);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Guardado correctamente")),
                );
              } else {
                await controller.actualizar(itemId!, item);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Actualizado correctamente")),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: $e")),
              );
            }
          },
          icon: Icon(isNew ? Icons.save : Icons.update),
          label: Text(isNew ? "Guardar" : "Actualizar"),
        ),

        // Cancelar
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          onPressed: () async {
            final nuevo = controller.reset();
            onReset?.call(nuevo);
          },
          icon: const Icon(Icons.cancel),
          label: const Text("Cancelar"),
        ),
      ],
    );
  }
}
