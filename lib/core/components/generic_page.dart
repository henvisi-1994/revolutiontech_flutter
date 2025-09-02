import 'package:flutter/material.dart';
import 'package:template_flutter/core/components/selectable_list_grid.dart';
import 'package:template_flutter/core/shared/controller/infraestructure/base_controller.dart';
import 'package:template_flutter/core/components/action_buttons.dart';
import 'package:template_flutter/core/shared/http/domain/base_entity.dart';

typedef FormBuilder<T> = Widget Function(
    BuildContext context, T item, void Function(T) onChanged);

typedef ItemBuilder<T> = Widget Function(T item, bool isSelected);

class GenericPage<T extends BaseEntity> extends StatefulWidget {
  final String title;
  final BaseController<T> controller;
  final List<T> items;
  final FormBuilder<T> formBuilder;
  final ItemBuilder<T> itemBuilder;

  const GenericPage({
    super.key,
    required this.title,
    required this.controller,
    required this.items,
    required this.formBuilder,
    required this.itemBuilder,
  });

  @override
  State<GenericPage<T>> createState() => _GenericPageState<T>();
}

class _GenericPageState<T extends BaseEntity> extends State<GenericPage<T>>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<T> selectedItems = [];
  T? editingItem;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void startEditing(T item) {
    setState(() {
      editingItem = item;
    });
    tabController.animateTo(0);
  }

  void resetEditing() {
    setState(() {
      editingItem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "Formulario"),
            Tab(text: "Listado"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // 🔹 Formulario
          // 🔹 Formulario
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 🔹 Usamos un item temporal si editingItem es null
                    Builder(builder: (context) {
                      final currentItem = editingItem ??
                          widget.controller
                              .reset(); // <- necesitas que BaseController tenga createEmpty()
                      return Column(
                        children: [
                          widget.formBuilder(context, currentItem, (updated) {
                            setState(() {
                              editingItem = updated;
                            });
                          }),
                          const SizedBox(height: 12),
                          ActionButtons<T>(
                            controller: widget.controller,
                            item: currentItem,
                            itemId: editingItem?.id?.toString(), // null = crear
                            onReset: (nuevo) => resetEditing(),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // 🔹 Listado
          Column(
            children: [
              Expanded(
                child: SelectableListGrid<T>(
                  items: widget.items,
                  title: widget.title,
                  onSelectionChange: (selection) {
                    setState(() => selectedItems = selection);
                  },
                  itemBuilder: widget.itemBuilder,
                  onEdit: startEditing,
                  onDelete: (item) {
                    setState(() {
                      widget.items.remove(item);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Eliminado")),
                    );
                  },
                ),
              ),
              if (selectedItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Seleccionados: ${selectedItems.length}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
