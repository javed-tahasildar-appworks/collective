// To parse this JSON data, do
//
//     final transactionResponseModel = transactionResponseModelFromJson(jsonString);

import 'dart:convert';

TransactionResponseModel transactionResponseModelFromJson(String str) =>
    TransactionResponseModel.fromJson(json.decode(str));

String transactionResponseModelToJson(TransactionResponseModel data) =>
    json.encode(data.toJson());

class TransactionResponseModel {
  String? transactionId;
  String? date;
  String? time;
  String? paymentMode;
  String? status;
  int? amount;

  TransactionResponseModel({
    this.transactionId,
    this.date,
    this.time,
    this.paymentMode,
    this.status,
    this.amount,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) =>
      TransactionResponseModel(
        transactionId: json["transaction_id"],
        date: json["date"],
        time: json["time"],
        paymentMode: json["payment_mode"],
        status: json["status"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "date": date,
        "time": time,
        "payment_mode": paymentMode,
        "status": status,
        "amount": amount,
      };
}
