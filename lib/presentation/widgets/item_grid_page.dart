import 'package:envirosense/core/constants/colors.dart';
import 'package:envirosense/presentation/widgets/add_item_card.dart';
import 'package:flutter/material.dart';

class ItemGridPage<T> extends StatefulWidget {
  final List<T> allItems;
  final Widget Function(T item) itemBuilder;
  final String Function(T item) getItemName;
  final VoidCallback onAddPressed;

  const ItemGridPage({
    super.key,
    required this.allItems,
    required this.itemBuilder,
    required this.getItemName,
    required this.onAddPressed,
  });

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
  void didUpdateWidget(covariant ItemGridPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allItems != widget.allItems) {
      _filteredItems = widget.allItems;
      _filterItems();
    }
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search a ${T.toString().toLowerCase()}',
              prefixIcon: const Icon(Icons.search),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                  return AddItemCard(
                    onTap: widget.onAddPressed,
                    title: 'Add a ${T.toString()}',
                    backgroundColor: AppColors.secondaryColor,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
