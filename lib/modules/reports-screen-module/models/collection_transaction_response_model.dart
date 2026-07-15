// To parse this JSON data, do
//
//     final collectionTransactionResponseModel = collectionTransactionResponseModelFromJson(jsonString);

import 'dart:convert';

CollectionTransactionResponseModel collectionTransactionResponseModelFromJson(
        String str) =>
    CollectionTransactionResponseModel.fromJson(json.decode(str));

String collectionTransactionResponseModelToJson(
        CollectionTransactionResponseModel data) =>
    json.encode(data.toJson());

class CollectionTransactionResponseModel {
  String? clientPhoto;
  String? clientName;
  String? clientId;
  String? transactionId;
  String? transactionDate;
  String? transactionTime;
  String? paymentMode;
  int? amount;
  String? accountType;
  String? accountNumber;
  String? status;

  CollectionTransactionResponseModel({
    this.clientPhoto,
    this.clientName,
    this.clientId,
    this.transactionId,
    this.transactionDate,
    this.transactionTime,
    this.paymentMode,
    this.amount,
    this.accountType,
    this.accountNumber,
    this.status,
  });

  factory CollectionTransactionResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CollectionTransactionResponseModel(
        clientPhoto: json["client_photo"],
        clientName: json["client_name"],
        clientId: json["client_id"],
        transactionId: json["transaction_id"],
        transactionDate: json["transaction_date"],
        transactionTime: json["transaction_time"],
        paymentMode: json["payment_mode"],
        amount: json["amount"],
        accountType: json["account_type"],
        accountNumber: json["account_number"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "client_photo": clientPhoto,
        "client_name": clientName,
        "client_id": clientId,
        "transaction_id": transactionId,
        "transaction_date": transactionDate,
        "transaction_time": transactionTime,
        "payment_mode": paymentMode,
        "amount": amount,
        "account_type": accountType,
        "account_number": accountNumber,
        "status": status,
      };
}
