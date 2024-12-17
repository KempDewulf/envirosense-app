import 'package:flutter/material.dart';

class ItemGridPage<T> extends StatefulWidget {
  final List<T> allItems;
  final Widget Function(T item) itemBuilder;
  final String searchHintText;
  final String Function(T item) getItemName;
  final VoidCallback onAddPressed;

  const ItemGridPage({
    Key? key,
    required this.allItems,
    required this.itemBuilder,
    required this.searchHintText,
    required this.getItemName,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  _ItemGridPageState<T> createState() => _ItemGridPageState<T>();
}

class _ItemGridPageState<T> extends State<ItemGridPage<T>> {
  final TextEditingController _searchController = TextEditingController();
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.allItems;
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.allItems.where((item) {
        final itemName = widget.getItemName(item).toLowerCase();
        return itemName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: widget.searchHintText,
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            itemCount: _filteredItems.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              if (index < _filteredItems.length) {
                var item = _filteredItems[index];
                return widget.itemBuilder(item);
              } else {
                // 'Add' card or button
                return GestureDetector(
                  onTap: widget.onAddPressed,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}