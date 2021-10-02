part of multi_select_form_field;

class MultiSelectFormField<T> extends FormField<T> {
  MultiSelectFormField({
    Key? key,
    FocusNode? focusNode,
    InputDecoration? decoration,
    required MultiSelectController<T> controller,
    Widget Function(BuildContext context, List<T> itensSelected)?
        itensSelectedbuilder,
    required Widget Function(
      T item,
      Function() onDelete,
    )
        itemSelectedBuilder,
    required List<T> itens,
    String? Function(List<T> itens)? validator,
    required Widget Function(
            T item, bool selected, Function(bool selected) onChange)
        itemTileBuilder,
    Function(List<T> itens)? onChanged,
    String? textConfirm,
    String? title,
    List<T>? initialValue,
  }) : super(
          key: key,
          validator: (_) => validator?.call(controller.value),
          builder: (field) {
            return MultiSelect<T>(
              focusNode: focusNode ?? FocusNode(),
              controller: controller,
              decoration: decoration,
              field: field,
              itensSelectedbuilder: itensSelectedbuilder,
              itemSelectedbuilder: itemSelectedBuilder,
              itemTileBuilder: itemTileBuilder,
              error: field.errorText,
              itens: itens,
              onChanged: onChanged,
              title: title,
              textConfirm: textConfirm,
            );
          },
        ) {
    if (initialValue != null) {
      controller.value = initialValue;
    }
  }
}

class MultiSelect<T> extends StatefulWidget {
  const MultiSelect({
    Key? key,
    required this.focusNode,
    this.decoration,
    this.error,
    required this.controller,
    required this.itemSelectedbuilder,
    required this.itens,
    this.onChanged,
    this.itensSelectedbuilder,
    required this.itemTileBuilder,
    required this.field,
    this.title,
    this.textConfirm,
  }) : super(key: key);

  final Widget Function(BuildContext context, List<T> itensSelected)?
      itensSelectedbuilder;
  final FocusNode focusNode;
  final InputDecoration? decoration;
  final String? error;
  final MultiSelectController<T> controller;
  final Widget Function(
    T item,
    Function() onDelete,
  ) itemSelectedbuilder;
  final Widget Function(T item, bool selected, Function(bool selected) onChange)
      itemTileBuilder;
  final List<T> itens;
  final Function(List<T> itens)? onChanged;
  final FormFieldState<T> field;
  final String? textConfirm;
  final String? title;

  @override
  _MultiSelectState<T> createState() => _MultiSelectState<T>();
}

class _MultiSelectState<T> extends State<MultiSelect<T>> {
  bool _isHovering = false;

  void _handleFocusChange() {
    setState(() {});
  }

  void _handleHover(bool hover) {
    setState(() {
      _isHovering = hover;
    });
  }

  @override
  void initState() {
    widget.focusNode.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusNode: widget.focusNode,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _MultiselectDialog(
            controller: widget.controller,
            itens: widget.itens,
            field: widget.field,
            itemTileBuilder: widget.itemTileBuilder,
            onChanged: widget.onChanged,
            title: widget.title,
            textConfirm: widget.textConfirm,
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: InputDecorator(
          decoration: (widget.decoration ?? const InputDecoration())
              .applyDefaults(Theme.of(context).inputDecorationTheme)
              .copyWith(
                errorText: widget.error,
              ),
          isFocused: widget.focusNode.hasFocus,
          isHovering: _isHovering,
          isEmpty: widget.controller.value.isEmpty,
          child: ValueListenableBuilder<List<T>>(
            valueListenable: widget.controller,
            builder: (context, itensSelected, _) {
              return widget.itensSelectedbuilder
                      ?.call(context, itensSelected) ??
                  Wrap(
                    children: itensSelected
                        .map(
                          (e) => widget.itemSelectedbuilder(
                            e,
                            () {
                              widget.controller.value = List.from(itensSelected)
                                ..removeWhere((element) => element == e);
                              widget.onChanged?.call(widget.controller.value);
                            },
                          ),
                        )
                        .toList(),
                  );
            },
          ),
        ),
      ),
    );
  }
}
