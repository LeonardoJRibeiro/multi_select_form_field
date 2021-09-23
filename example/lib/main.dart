import 'package:flutter/material.dart';

import 'package:multi_select_form_field/multi_select_form_field.dart';

void main() {
  runApp(Example());
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final colorsController = MultiSelectController<ColorModel>();
  final formKey = GlobalKey<FormState>();
  final data = [
    ColorModel(name: 'Red', color: Colors.red),
    ColorModel(name: 'Blue', color: Colors.blue),
    ColorModel(name: 'Green', color: Colors.green),
    ColorModel(name: 'Yellow', color: Colors.yellow),
    ColorModel(name: 'Grey', color: Colors.grey),
    ColorModel(name: 'White', color: Colors.white),
    ColorModel(name: 'Cyan', color: Colors.cyan),
  ];

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Select Form Field Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MultiSelectFormField<ColorModel>(
                    title: 'Select colors',
                    controller: colorsController,
                    itemSelectedBuilder: (item, onDelete) => Chip(
                      label: Text(item.name),
                      onDeleted: onDelete,
                      backgroundColor: item.color,
                    ),
                    itens: data,
                    itemTileBuilder: (item, selected, onChange) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SwitchListTile(
                          title: Text(item.name),
                          tileColor: item.color,
                          value: selected,
                          onChanged: onChange,
                        ),
                      );
                    },
                    validator: (itens) {
                      if (itens.isEmpty) {
                        return 'At least one item is required';
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<List<ColorModel>>(
                      valueListenable: colorsController,
                      builder: (context, colorsSelected, child) => Text(
                          'Colors selected: ${[
                        for (final v in colorsSelected) v.name
                      ]}'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      formKey.currentState?.validate();
                    },
                    child: const Text('Validate'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorModel {
  final String name;
  final Color color;

  ColorModel({
    required this.name,
    required this.color,
  });

  ColorModel copyWith({
    String? name,
    Color? color,
  }) {
    return ColorModel(
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  String toString() => 'ColorModel(name: $name, color: $color)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ColorModel && other.name == name && other.color == color;
  }

  @override
  int get hashCode => name.hashCode ^ color.hashCode;
}
