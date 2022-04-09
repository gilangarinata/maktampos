import 'dart:convert';

SummaryResponse summaryResponseFromJson(String str) => SummaryResponse.fromJson(json.decode(str));

class SummaryResponse {
  SummaryResponse({
    this.date,
    this.totalFund,
    this.totalExpense,
    this.totalIncome,
    this.balance,
    this.urlExcel,
  });

  DateTime? date;
  int? totalFund;
  int? totalExpense;
  int? totalIncome;
  int? balance;
  String? urlExcel;

  factory SummaryResponse.fromJson(Map<String, dynamic> json) => SummaryResponse(
    date: DateTime.parse(json["date"]),
    totalFund: json["totalFund"],
    totalExpense: json["totalExpense"],
    totalIncome: json["totalIncome"],
    balance: json["balance"],
    urlExcel: json["urlExcel"],
  );
}
