// To parse this JSON data, do
//
//     final stockModel = stockModelFromJson(jsonString);

import 'dart:convert';

List<StockModel> stockModelFromJson(String str) => List<StockModel>.from(json.decode(str).map((x) => StockModel.fromJson(x)));

String stockModelToJson(List<StockModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockModel {
    int id;
    String name;
    String tag;
    String color;
    List<Criterion> criteria;

    StockModel({
        required this.id,
        required this.name,
        required this.tag,
        required this.color,
        required this.criteria,
    });

    factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
        id: json["id"],
        name: json["name"],
        tag: json["tag"],
        color: json["color"],
        criteria: List<Criterion>.from(json["criteria"].map((x) => Criterion.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tag": tag,
        "color": color,
        "criteria": List<dynamic>.from(criteria.map((x) => x.toJson())),
    };
}

class Criterion {
    String type;
    String text;
    Map<String, dynamic>? variable;

    Criterion({
        required this.type,
        required this.text,
        this.variable,
    });

    factory Criterion.fromJson(Map<String, dynamic> json) => Criterion(
        type: json["type"],
        text: json["text"],
        variable: json["variable"] != null ? Map<String, dynamic>.from(json["variable"]) : null,

    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "text": text,
        "variable": variable,
    };
}