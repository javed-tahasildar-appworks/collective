// To parse this JSON data, do
//
//     final clientResponseModel = clientResponseModelFromJson(jsonString);

import 'dart:convert';

CustomerResponseModel customerResponseModelFromJson(String str) =>
    CustomerResponseModel.fromJson(json.decode(str));

String customerResponseModelToJson(CustomerResponseModel data) =>
    json.encode(data.toJson());

class CustomerResponseModel {
  String clientPhoto;
  String clientId;
  String clientName;
  //  Loan Ac / Saving Ac received 100/- Rs. (Refer PhonePe)
  String lastTransaction;
  String transactionTime;
  String transactionDate;

  CustomerResponseModel(
      {required this.clientPhoto,
      required this.clientId,
      required this.clientName,
      required this.lastTransaction,
      required this.transactionTime,
      required this.transactionDate});

  factory CustomerResponseModel.fromJson(Map<String, dynamic> json) =>
      CustomerResponseModel(
          clientPhoto: json["client_photo"],
          clientId: json["client_id"],
          clientName: json["client_name"],
          lastTransaction: json["last_transaction"],
          transactionTime: json["transaction_time"],
          transactionDate: json["trasaction_date"]);

  Map<String, dynamic> toJson() => {
        "client_photo": clientPhoto,
        "client_id": clientId,
        "client_name": clientName,
        "last_transaction": lastTransaction,
        "transaction_time": transactionTime,
        "transaction_date": transactionDate
      };
}
