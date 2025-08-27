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
    this.searchTextOf, // cómo obtener texto buscable de T
    this.onSelectionChange, // notifica selección al padre
  });

  /// Elementos a mostrar
  final List<T> items;

  /// Construye el widget de cada item. Recibe (item, isSelected)
  final Widget Function(T item, bool isSelected) itemBuilder;

  /// Título del AppBar
  final String title;

  /// Tamaño de página inicial
  final int pageSize;

  /// Cómo obtener el texto para búsqueda (por defecto: busca en todos los campos)
  final String Function(T item)? searchTextOf;

  /// Callback cuando cambia la selección
  final ValueChanged<List<T>>? onSelectionChange;

  @override
  State<SelectableListGrid<T>> createState() => _SelectableListGridState<T>();
}

class _SelectableListGridState<T extends BaseEntity>
    extends State<SelectableListGrid<T>> {
  // UI state
  bool isSelectionMode = false;
  bool _isGridMode = false;

  // búsqueda
  String _query = "";

  // paginación
  late int _pageSize;
  int _currentPage = 1;

  // selección basada en id para persistir entre filtros/páginas
  final Set<int> _selectedIds = <int>{};

  @override
  void initState() {
    super.initState();
    _pageSize = widget.pageSize;
  }

  // ---- Helpers de búsqueda y paginación ----
  String _textOf(T item) {
    if (widget.searchTextOf != null) {
      return widget.searchTextOf!(item).toLowerCase();
    }

    // Búsqueda genérica: convierte el objeto a JSON y busca en todos los campos
    try {
      final jsonString = jsonEncode(item);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

      // Concatena todos los valores de los campos en un solo string
      final allValues = jsonMap.values
          .where((value) => value != null)
          .map((value) => value.toString().toLowerCase())
          .join(' ');

      return allValues;
    } catch (e) {
      // Fallback: usa toString() si no se puede convertir a JSON
      return item.toString().toLowerCase();
    }
  }

  List<T> get _filteredItems {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase().trim();

    if (q.isEmpty) return widget.items;

    return widget.items.where((item) {
      final searchText = _textOf(item);
      return searchText.contains(q);
    }).toList();
  }

  int get _totalPages {
    final total = _filteredItems.length;
    if (total == 0) return 1;
    return ((total - 1) / _pageSize).floor() + 1;
  }

  List<T> get _pagedItems {
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, _filteredItems.length);
    if (start >= _filteredItems.length) return const [];
    return _filteredItems.sublist(start, end);
  }

  void _resetPagination() {
    setState(() {
      _currentPage = 1;
    });
  }

  int _safeId(T item) => item.id ?? item.hashCode;

  // ---- Selección ----
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

  void _selectAllCurrentPage() {
    final ids = _pagedItems.map((e) => _safeId(e));
    setState(() => _selectedIds.addAll(ids));
    _emitSelection();
  }

  void _unselectAllCurrentPage() {
    final ids = _pagedItems.map((e) => _safeId(e)).toSet();
    setState(() => _selectedIds.removeWhere((id) => ids.contains(id)));
    _emitSelection();
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

  // ---- Build ----
  @override
  Widget build(BuildContext context) {
    // asegurar página válida si cambió el filtro/tamaño
    final totalPages = _totalPages;
    if (_currentPage > totalPages) {
      _currentPage = totalPages > 0 ? totalPages : 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSelection,
              )
            : const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: Icon(_isGridMode ? Icons.list : Icons.grid_on),
            tooltip: _isGridMode ? "Ver como lista" : "Ver como grid",
            onPressed: () => setState(() => _isGridMode = !_isGridMode),
          ),
          if (isSelectionMode)
            PopupMenuButton<String>(
              tooltip: "Selección",
              onSelected: (v) {
                if (v == 'select_page') _selectAllCurrentPage();
                if (v == 'unselect_page') _unselectAllCurrentPage();
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'select_page',
                  child: Text('Seleccionar página'),
                ),
                PopupMenuItem(
                  value: 'unselect_page',
                  child: Text('Quitar selección página'),
                ),
              ],
              icon: const Icon(Icons.checklist),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                // Búsqueda
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Buscar...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _query = value;
                        _resetPagination();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Tamaño de página
                DropdownButton<int>(
                  value: _pageSize,
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _pageSize = v;
                      _resetPagination();
                    });
                  },
                  items: const [5, 10, 20, 50]
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text("$e/pág")))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isGridMode ? _buildGrid() : _buildList(),
          ),
          _buildPaginator(totalPages),
        ],
      ),
    );
  }

  // ---- Vistas ----
  Widget _buildGrid() {
    final page = _pagedItems;
    if (page.isEmpty) {
      return const Center(
        child: Text("No se encontraron resultados"),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: page.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, index) {
        final item = page[index];
        final selected = _isSelected(item);
        return InkWell(
          onTap: () => isSelectionMode ? _toggleSelect(item) : null,
          onLongPress: () => _enterSelectionWith(item),
          child: Stack(
            children: [
              Positioned.fill(child: widget.itemBuilder(item, selected)),
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
        );
      },
    );
  }

  Widget _buildList() {
    final page = _pagedItems;
    if (page.isEmpty) {
      return const Center(
        child: Text("No se encontraron resultados"),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: page.length,
      itemBuilder: (_, index) {
        final item = page[index];
        final selected = _isSelected(item);
        return InkWell(
          onTap: () => isSelectionMode ? _toggleSelect(item) : null,
          onLongPress: () => _enterSelectionWith(item),
          child: Row(
            children: [
              Expanded(child: widget.itemBuilder(item, selected)),
              if (isSelectionMode)
                Checkbox(
                  value: selected,
                  onChanged: (_) => _toggleSelect(item),
                ),
            ],
          ),
        );
      },
    );
  }

  // ---- Paginador ----
  Widget _buildPaginator(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: "Primera",
            onPressed: _currentPage > 1
                ? () => setState(() => _currentPage = 1)
                : null,
            icon: const Icon(Icons.first_page),
          ),
          IconButton(
            tooltip: "Anterior",
            onPressed:
                _currentPage > 1 ? () => setState(() => _currentPage--) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 8),
          Text("Página $_currentPage de $totalPages"),
          const SizedBox(width: 8),
          IconButton(
            tooltip: "Siguiente",
            onPressed: _currentPage < totalPages
                ? () => setState(() => _currentPage++)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
          IconButton(
            tooltip: "Última",
            onPressed: _currentPage < totalPages
                ? () => setState(() => _currentPage = totalPages)
                : null,
            icon: const Icon(Icons.last_page),
          ),
          const Spacer(),
          if (isSelectionMode)
            Text(
              "Seleccionados: ${_selectedIds.length}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
