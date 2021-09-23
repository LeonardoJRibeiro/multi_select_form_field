part of multi_select_form_field;

class _MultiselectDialog<T> extends StatelessWidget {
  const _MultiselectDialog({
    Key? key,
    required this.controller,
    required this.itens,
    this.onChanged,
    this.title,
    required this.field,
    required this.itemTileBuilder,
    this.textConfirm,
  }) : super(key: key);

  final MultiSelectController<T> controller;
  final List<T> itens;
  final Function(List<T> itens)? onChanged;
  final Widget Function(T item, bool selected, Function(bool selected) onChange)
      itemTileBuilder;
  final String? title;
  final FormFieldState<T> field;
  final String? textConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title ?? '',
      ),
      content: ValueListenableBuilder<List<T>>(
        valueListenable: controller,
        builder: (context, itensSelected, _) {
          return SingleChildScrollView(
            child: Column(
              children: itens
                  .map(
                    (e) => itemTileBuilder(
                      e,
                      itensSelected.contains(e),
                      (selecionado) {
                        if (selecionado) {
                          controller.value = List.from(itensSelected)..add(e);
                          field.validate();
                        } else {
                          controller.value = List.from(itensSelected)
                            ..removeWhere((element) => element == e);
                          field.validate();
                        }
                        onChanged?.call(controller.value);
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(textConfirm ?? 'Ok'),
        ),
      ],
    );
  }
}
