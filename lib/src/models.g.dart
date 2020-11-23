// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonForm _$JsonFormFromJson(Map<String, dynamic> json) {
  return JsonForm(
    groups: (json['groups'] as List)
        ?.map(
            (e) => e == null ? null : Group.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$JsonFormToJson(JsonForm instance) => <String, dynamic>{
      'groups': instance.groups,
    };

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(
    title: json['title'] as String,
    description: json['description'] as String,
    subtotal: (json['subtotal'] as num)?.toDouble(),
    value: json['value'],
    type: json['type'] as String,
    items: (json['items'] as List)
        ?.map(
            (e) => e == null ? null : Item.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..key = json['key'] as String;
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'key': instance.key,
      'title': instance.title,
      'description': instance.description,
      'subtotal': instance.subtotal,
      'value': instance.value,
      'type': instance.type,
      'items': instance.items,
    };

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    label: json['label'] as String,
    price: (json['price'] as num)?.toDouble(),
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'label': instance.label,
      'price': instance.price,
      'value': instance.value,
    };
