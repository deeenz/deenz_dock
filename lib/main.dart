import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Dock(),
        ),
      ),
    );
  }
}

class Dock extends StatefulWidget {
  const Dock({
    super.key,
  });

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  final List<IconData> _items = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];
  int _tappedIndex = -1;
  IconData? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          _items.length,
          (index) => _buildDraggableIcon(index),
        ),
      ),
    );
  }

  Widget _buildDraggableIcon(int index) {
    final icon = _items[index];

    return DragTarget<IconData>(
      onAcceptWithDetails: (data) {},
      onWillAcceptWithDetails: (data) {
        setState(() {
          _items.removeWhere((e) => e == data.data);
          _items.insert(index, data.data);
        });
        return true;
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<IconData>(
          data: icon,
          feedback: _iconContainer(icon, true),
          onDragStarted: () {
            selectedIcon = _items.removeAt(index);
            _tappedIndex = index;
            setState(() {});
          },
          onDragCompleted: () {
            if (_items.length < 5) {
              _items.insert(_tappedIndex, selectedIcon!);
              setState(() {});
            }
          },
          onDraggableCanceled: (vel, off) {
            if (_items.length < 5) {
              _items.insert(_tappedIndex, selectedIcon!);
              setState(() {});
            }
          },
          childWhenDragging: _iconContainer(icon, false),
          child: Container(
            width: 48,
            height: 48,
            constraints: const BoxConstraints(minWidth: 48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.primaries[icon.hashCode % Colors.primaries.length],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: _iconContainer(icon, false),
          ),
        );
      },
    );
  }

  Widget _iconContainer(IconData icon, bool dragging) {
    return Container(
      width: dragging ? 60 : 48,
      height: dragging ? 60 : 48,
      constraints: const BoxConstraints(minWidth: 48),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.primaries[icon.hashCode % Colors.primaries.length],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
