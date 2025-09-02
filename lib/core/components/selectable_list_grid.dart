import 'package:flutter/material.dart';
import 'package:template_flutter/core/shared/http/domain/base_entity.dart';
import 'dart:convert';

class SelectableListGrid<T extends BaseEntity> extends StatefulWidget {
  const SelectableListGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.title = "Selección",
    this.pageSize = 10,
    this.searchTextOf,
    this.onSelectionChange,
    this.onEdit,
    this.onDelete,
  });

  final List<T> items;
  final Widget Function(T item, bool isSelected) itemBuilder;
  final String title;
  final int pageSize;
  final String Function(T item)? searchTextOf;
  final ValueChanged<List<T>>? onSelectionChange;

  /// Callbacks nuevos
  final void Function(T item)? onEdit;
  final void Function(T item)? onDelete;

  @override
  State<SelectableListGrid<T>> createState() => _SelectableListGridState<T>();
}

class _SelectableListGridState<T extends BaseEntity>
    extends State<SelectableListGrid<T>> {
  bool isSelectionMode = false;
  bool _isGridMode = false;
  String _query = "";
  late int _pageSize;
  int _currentPage = 1;
  final Set<int> _selectedIds = <int>{};

  @override
  void initState() {
    super.initState();
    _pageSize = widget.pageSize;
  }

  String _textOf(T item) {
    if (widget.searchTextOf != null) {
      return widget.searchTextOf!(item).toLowerCase();
    }
    try {
      final jsonString = jsonEncode(item);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final allValues = jsonMap.values
          .where((value) => value != null)
          .map((value) => value.toString().toLowerCase())
          .join(' ');
      return allValues;
    } catch (_) {
      return item.toString().toLowerCase();
    }
  }

  List<T> get _filteredItems {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase().trim();
    return widget.items.where((item) {
      final searchText = _textOf(item);
      return searchText.contains(q);
    }).toList();
  }

  int get _totalPages => _filteredItems.isEmpty
      ? 1
      : ((_filteredItems.length - 1) / _pageSize).floor() + 1;

  List<T> get _pagedItems {
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filteredItems.length);
    if (start >= _filteredItems.length) return const [];
    return _filteredItems.sublist(start, end);
  }

  int _safeId(T item) => item.id ?? item.hashCode;
  bool _isSelected(T item) => _selectedIds.contains(_safeId(item));

  void _toggleSelect(T item) {
    final id = _safeId(item);
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
    _emitSelection();
  }

  void _enterSelectionWith(T item) {
    final id = _safeId(item);
    if (!isSelectionMode) {
      setState(() {
        isSelectionMode = true;
        _selectedIds.add(id);
      });
      _emitSelection();
    }
  }

  void _emitSelection() {
    if (widget.onSelectionChange != null) {
      final selected =
          widget.items.where((e) => _selectedIds.contains(_safeId(e))).toList();
      widget.onSelectionChange!(selected);
    }
  }

  void _clearSelection() {
    setState(() {
      isSelectionMode = false;
      _selectedIds.clear();
    });
    _emitSelection();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _totalPages;
    if (_currentPage > totalPages) _currentPage = totalPages;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close), onPressed: _clearSelection)
            : const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: Icon(_isGridMode ? Icons.list : Icons.grid_on),
            tooltip: _isGridMode ? "Ver como lista" : "Ver como grid",
            onPressed: () => setState(() => _isGridMode = !_isGridMode),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _isGridMode ? _buildGrid() : _buildList()),
          _buildPaginator(totalPages),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final page = _pagedItems;
    if (page.isEmpty) {
      return const Center(child: Text("No se encontraron resultados"));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: page.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1),
      itemBuilder: (_, index) {
        final item = page[index];
        final selected = _isSelected(item);
        return Card(
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => isSelectionMode
                      ? _toggleSelect(item)
                      : _enterSelectionWith(item),
                  onLongPress: () => _enterSelectionWith(item),
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: widget.itemBuilder(item, selected)),
                      if (isSelectionMode)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Checkbox(
                            value: selected,
                            onChanged: (_) => _toggleSelect(item),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              _buildActionButtons(item), // 👈 botones aquí
            ],
          ),
        );
      },
    );
  }

  Widget _buildList() {
    final page = _pagedItems;
    if (page.isEmpty) {
      return const Center(child: Text("No se encontraron resultados"));
    }
    return ListView.builder(
      itemCount: page.length,
      itemBuilder: (_, index) {
        final item = page[index];
        final selected = _isSelected(item);
        return Card(
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => isSelectionMode
                      ? _toggleSelect(item)
                      : _enterSelectionWith(item),
                  onLongPress: () => _enterSelectionWith(item),
                  child: widget.itemBuilder(item, selected),
                ),
              ),
              if (isSelectionMode)
                Checkbox(
                  value: selected,
                  onChanged: (_) => _toggleSelect(item),
                ),
              _buildActionButtons(item), // 👈 botones aquí
            ],
          ),
        );
      },
    );
  }

  /// ---- Botones Editar y Eliminar ----
  Widget _buildActionButtons(T item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          tooltip: "Editar",
          onPressed: widget.onEdit != null ? () => widget.onEdit!(item) : null,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: "Eliminar",
          onPressed:
              widget.onDelete != null ? () => widget.onDelete!(item) : null,
        ),
      ],
    );
  }

  Widget _buildPaginator(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Text("Página $_currentPage de $totalPages"),
          const Spacer(),
          if (isSelectionMode) Text("Seleccionados: ${_selectedIds.length}"),
        ],
      ),
    );
  }
}
