// To parse this JSON data, do
//
//     final clientResponseModel = clientResponseModelFromJson(jsonString);

import 'dart:convert';

ClientResponseModel clientResponseModelFromJson(String str) =>
    ClientResponseModel.fromJson(json.decode(str));

String clientResponseModelToJson(ClientResponseModel data) =>
    json.encode(data.toJson());

class ClientResponseModel {
  String clientPhoto;
  String clientId;
  String clientName;

  ClientResponseModel({
    required this.clientPhoto,
    required this.clientId,
    required this.clientName,
  });

  factory ClientResponseModel.fromJson(Map<String, dynamic> json) =>
      ClientResponseModel(
        clientPhoto: json["client_photo"],
        clientId: json["client_id"],
        clientName: json["client_name"],
      );

  Map<String, dynamic> toJson() => {
        "client_photo": clientPhoto,
        "client_id": clientId,
        "client_name": clientName,
      };
}
