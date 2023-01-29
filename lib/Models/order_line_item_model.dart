import 'dart:ffi';

import 'package:red_leaf/Models/customer_billing_model.dart';
import 'package:red_leaf/Models/order_metadata_model.dart';
import 'package:red_leaf/Models/order_taxes_model.dart';
import 'package:red_leaf/Models/product_category_model.dart';
import 'package:red_leaf/Models/product_image_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';

import 'customer_shipping_model.dart';

class OrderLineItemModel {
  OrderLineItemModel({
    required this.id,
    required this.product_id,
    required this.variation_id,
    required this.quantity,
    required this.name,
    required this.tax_class,
    required this.subtotal,
    required this.subtotal_tax,
    required this.total,
    required this.total_tax,

    required this.taxes,
    required this.meta_data,
    required this.billing,
    required this.shipping,



  });

  final int id;
  final int product_id;
  final int variation_id;
  final int quantity;
  final String name;
  final String tax_class;
  final String subtotal;
  final String subtotal_tax;
  final String total;
  final String total_tax;

  final List<OrderTaxesModel> taxes;
  final List<ProductMetaDataModel> meta_data;

  final List<customerBillingModel> billing;
  final List<customerShippingModel> shipping;


  factory OrderLineItemModel.fromJson(Map<String, dynamic> json) => OrderLineItemModel(
        id: json["id"],
        product_id: json["product_id"],
        variation_id: json["variation_id"],
        quantity: json["quantity"],
        name: json["name"],
        tax_class: json["tax_class"],
        subtotal: json["subtotal"],
        subtotal_tax: json["subtotal_tax"],
        total: json["total"],
        total_tax: json["total_tax"],
        taxes: List.from(json["taxes"]).map((e) => OrderTaxesModel.fromJson(e)).toList(),
        meta_data: List.from(json["meta_data"]).map((e) => ProductMetaDataModel.fromJson(e)).toList(),
        billing: List.from(json["billing"]).map((e) => customerBillingModel.fromJson(e)).toList(),
        shipping: List.from(json["shipping"]).map((e) => customerShippingModel.fromJson(e)).toList(),

      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product_id": product_id,
        "variation_id": variation_id,
        "quantity": quantity,
        "name": name,
        "tax_class": tax_class,
        "subtotal": subtotal,
        "subtotal_tax": subtotal_tax,
        "total": total,
        "total_tax": total_tax,
        "taxes": taxes,
        "meta_data": meta_data,
        "billing": billing,
        "shipping": shipping,

      };

  static List<OrderLineItemModel> listFromJson(List data) {
    return data.map((e) => OrderLineItemModel.fromJson(e)).toList();
  }
}
