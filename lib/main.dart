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
  final List<IconData?> _items = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

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
    final icon = _items.toList()[index];
    return DragTarget<IconData>(
      onAcceptWithDetails: (data) {
        setState(() {
          _items.removeWhere((e) => e == data.data);
          _items.insert(index, data.data);
        });
      },
      onWillAcceptWithDetails: (details) {
        if (_items.length > 5) {
          _items.removeWhere((e) => e == null);
        }

        _items.insert(index, null);
        setState(() {});
        return true;
      },
      builder: (context, candidateData, rejectedData) {
        return Draggable<IconData>(
          data: icon,
          maxSimultaneousDrags: 1,
          onDragEnd: (details) {
            _items.removeWhere((e) => e == null);
            setState(() {});
          },
          feedback: _iconContainer(icon, true, candidateData.isNotEmpty),
          childWhenDragging: const SizedBox(),
          child: _iconContainer(icon, false, candidateData.isNotEmpty),
        );
      },
    );
  }

  Widget _iconContainer(IconData? icon, bool dragging, bool highlighted) {
    if (highlighted) {
      return const SizedBox(
        width: 48,
        height: 48,
      );
    }

    if (icon == null) {
      return const SizedBox();
    }

    return Container(
      width: dragging ? 60 : 48,
      height: dragging ? 60 : 48,
      constraints: const BoxConstraints(minWidth: 45),
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
