import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:json_to_store_menu/json_to_store_menu.dart';

class JsonStoreMenuExample extends StatefulWidget {
  JsonStoreMenuExample({Key key}) : super(key: key);

  @override
  _AllFields createState() => new _AllFields();
}

class _AllFields extends State<JsonStoreMenuExample> {
  final otherForm = json.encode({
    "groups": [
      {
        "key": "extras",
        "title": "Extras",
        "description": "It's a simple description",
        "subtotal": 0.25,
        "value": 1,
        "type": "single",
        "items": [
          {
            "label": "Label 1",
            "price": 0.25,
            "value": 1,
          },
          {
            "label": "Label 2",
            "price": 0.5,
            "value": 2,
          },
          {
            "label": "Label 3",
            "price": 1.25,
            "value": 3,
          },
          {
            "label": "Label 4",
            "price": 0.75,
            "value": 4,
          },
        ],
      },
      {
        "key": "dressings",
        "title": "Dressings",
        "description": "It's another simple description",
        "subtotal": 1.0,
        "value": [1, 2],
        "type": "multi",
        "items": [
          {
            "label": "Label 1",
            "price": 0.5,
            "value": 1,
          },
          {
            "label": "Label 2",
            "price": 0.5,
            "value": 2,
          },
          {
            "label": "Label 3",
            "price": 0.5,
            "value": 3,
          },
        ],
      },
      {
        "key": "size",
        "title": "Size",
        "description": "It's another simple description",
        "subtotal": 0.5,
        "value": 1,
        "type": "select",
        "items": [
          {
            "label": "Label 1",
            "price": 0.5,
            "value": 1,
          },
          {
            "label": "Label 2",
            "price": 0.5,
            "value": 2,
          },
          {
            "label": "Label 3",
            "price": 0.5,
            "value": 3,
          },
        ],
      },
    ]
  });
  double total = 0.0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Example"),
      ),
      body: new SingleChildScrollView(
        padding: EdgeInsets.only(left: 31, right: 31, bottom: 31),
        child: Column(
          children: [
            JsonStoreMenuBuilder(
              form: otherForm,
              itemTitleBuilder: (String title, double price) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "\$${price.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                    ),
                  ],
                );
              },
              groupDescriptionBuilder: (String description) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  ),
                );
              },
              groupTitleBuilder: (String title) {
                return Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              },
              dropdownBuilder:
                  (List<DropdownMenuItem<int>> items, int selected, Function onChange) {
                return SizedBox(
                  width: 250,
                  child: DropdownButton(
                    items: items,
                    value: selected,
                    isExpanded: true,
                    onChanged: onChange,
                  ),
                );
              },
              dropdownItemBuilder: (String title, double price) {
                return Expanded(
                  child: Text(
                    "$title - \$${price.toStringAsFixed(2)}",
                    textAlign: TextAlign.center,
                  ),
                );
              },
              onChanged: (dynamic state, double total) {
                print(total);
                setState(() {
                  this.total = total;
                });
              },
              onInit: (dynamic state, double total) {
                print(total);
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    this.total = total;
                  });
                });
              },
            ),
            SizedBox(height: 32),
            Text(
              "\$${total.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
