import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable(nullable: true)
class JsonForm {
  @JsonKey(name: "groups")
  List<Group> groups;

  JsonForm({this.groups});

  factory JsonForm.fromJson(Map<String, dynamic> json) => _$JsonFormFromJson(json);
  Map<String, dynamic> toJson() => _$JsonFormToJson(this);
}

@JsonSerializable(nullable: true)
class Group {
  @JsonKey(name: "key")
  String key;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "description")
  String description;
  @JsonKey(name: "subtotal")
  double subtotal;
  @JsonKey(name: "value")
  dynamic value;
  @JsonKey(name: "type")
  String type;
  @JsonKey(name: "items")
  List<Item> items;

  @JsonKey(name: "showHorizontal", defaultValue: false)
  bool showHorizontal = false;

  Group({
    this.title,
    this.description,
    this.subtotal,
    this.value,
    this.type,
    this.items,
    this.key,
    this.showHorizontal,
  });

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

@JsonSerializable(nullable: true)
class Item {
  @JsonKey(name: "label")
  String label;
  @JsonKey(name: "price")
  double price;
  @JsonKey(name: "value")
  int value;
  @JsonKey(ignore: true, defaultValue: false)
  bool selected = false;

  Item({this.label, this.price, this.value});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
