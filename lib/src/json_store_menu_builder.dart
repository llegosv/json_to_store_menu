import 'dart:convert';
import 'package:flutter/material.dart';

import 'models.dart';

class JsonStoreMenuBuilder extends StatefulWidget {
  JsonStoreMenuBuilder({
    @required this.form,
    @required this.itemTitleBuilder,
    @required this.groupTitleBuilder,
    @required this.onChanged,
    @required this.groupDescriptionBuilder,
    @required this.dropdownBuilder,
    @required this.dropdownItemBuilder,
    this.onInit,
  });

  final String form;
  final Function(dynamic, double) onChanged;
  final Function(dynamic, double) onInit;
  final Widget Function(String) groupTitleBuilder;
  final Widget Function(String) groupDescriptionBuilder;
  final Widget Function(String, double) itemTitleBuilder;
  final Widget Function(String, double) dropdownItemBuilder;
  final Widget Function(List<DropdownMenuItem<int>>, int, Function(int)) dropdownBuilder;

  @override
  _JsonStoreMenuBuilderState createState() => _JsonStoreMenuBuilderState();
}

class _JsonStoreMenuBuilderState extends State<JsonStoreMenuBuilder> {
  Map<String, int> _radioButtonsValues;
  Map<String, List> _checkboxesValues;
  bool firstTime;
  Map<String, dynamic> result;
  double subtotal;
  JsonForm form;

  @override
  void initState() {
    super.initState();
    _radioButtonsValues = {};
    _checkboxesValues = {};
    firstTime = true;
    result = {};
    subtotal = 0.0;
    form = JsonForm.fromJson(json.decode(widget.form));
  }

  List<Widget> _formToJson() {
    List<Widget> widgets = [];

    for (int index = 0; index < form.groups.length; index++) {
      final Group group = form.groups[index];

      widgets.add(widget.groupTitleBuilder(group.title));
      if (group.description != null) {
        widgets.add(widget.groupDescriptionBuilder(group.description));
      }

      if (group.type == "single") {
        if (firstTime) {
          _radioButtonsValues[group.key] = group.value;

          result[group.key] = {
            "value": group.value,
            "subtotal": group.subtotal,
          };
        }

        final List<Widget> groupItems = [];

        for (int itemIndex = 0; itemIndex < group.items.length; itemIndex++) {
          final item = group.items[itemIndex];
          final groupItemWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget.itemTitleBuilder(item.label, item.price),
              Radio<int>(
                value: item.value,
                groupValue: _radioButtonsValues[group.key],
                onChanged: (int newValue) {
                  setState(() {
                    _radioButtonsValues[group.key] = item.value;
                    result[group.key]['value'] = item.value;
                    result[group.key]['subtotal'] = item.price;
                  });

                  _handleChanges();
                },
              ),
            ],
          );

          if (group.showHorizontal) {
            groupItems.add(groupItemWidget);
          } else {
            widgets.add(groupItemWidget);
          }
        }

        if (group.showHorizontal) {
          widgets.add(Wrap(children: groupItems));
        }
      }

      if (group.type == "multi") {
        if (firstTime) {
          _checkboxesValues[group.key] = group.value;

          for (int i = 0; i < form.groups[index].items.length; i++) {
            form.groups[index].items[i].selected =
                _checkboxesValues[group.key].contains(form.groups[index].items[i].value);
          }

          result[group.key] = {
            "value": group.value,
            "subtotal": group.subtotal,
          };

          _updateSubtotalCheckboxes(group.key);
        }

        final List<Widget> groupItems = [];

        for (int itemIndex = 0; itemIndex < group.items.length; itemIndex++) {
          final item = group.items[itemIndex];
          final groupItemWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget.itemTitleBuilder(item.label, item.price),
              Checkbox(
                value: item.selected ?? false,
                onChanged: (bool value) {
                  result[group.key]['value'] = _checkboxesValues[group.key];
                  setState(() {
                    form.groups[index].items[itemIndex].selected = value;

                    if (value) {
                      result[group.key]['subtotal'] += item.price;
                      _checkboxesValues[group.key].add(item.value);
                    } else {
                      result[group.key]['subtotal'] -= item.price;
                      _checkboxesValues[group.key].remove(item.value);
                    }
                  });

                  _updateSubtotalCheckboxes(group.key);
                  _handleChanges();
                },
              ),
            ],
          );

          if (group.showHorizontal) {
            groupItems.add(groupItemWidget);
          } else {
            widgets.add(groupItemWidget);
          }
        }

        if (group.showHorizontal) {
          widgets.add(Wrap(children: groupItems));
        }
      }
      if (group.type == "select") {
        if (firstTime) {
          result[group.key] = {
            "value": group.value,
            "subtotal": group.subtotal,
          };
        }

        final items = group.items
            .map(
              (e) => DropdownMenuItem<int>(
                value: e.value,
                child: widget.dropdownItemBuilder(e.label, e.price),
              ),
            )
            .toList();

        widgets.add(widget.dropdownBuilder(
          items,
          result[group.key]['value'],
          (int value) {
            setState(() {
              result[group.key]['value'] = value;
              result[group.key]['subtotal'] =
                  group.items.singleWhere((item) => item.value == value).price;
            });

            _handleChanges();
          },
        ));
      }
    }

    if (firstTime && widget.onInit != null) {
      _calcSubtotal();
      widget.onInit(result, subtotal);
    }

    firstTime = false;

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _formToJson(),
    );
  }

  void _updateSubtotalCheckboxes(String groupKey) {
    result[groupKey]['subtotal'] = form.groups
        .singleWhere((group) => group.key == groupKey)
        .items
        .fold(0, (prev, item) => item.selected ? prev + item.price : prev);
  }

  void _calcSubtotal() {
    subtotal = 0;
    result.keys.forEach((key) {
      subtotal += result[key]['subtotal'];
    });
  }

  void _handleChanges() {
    _calcSubtotal();
    widget.onChanged(result, subtotal);
  }
}
