class BillPaymentsModel {
  String id;
  String customerName;
  String emailAddress;
  String meterNumber;
  String paymentMethod;
  String accountNumber;
  String billAmount;
  String sourceAccount;


  BillPaymentsModel({
    required this.id,
    required this.customerName,
    required this.emailAddress,
    required this.meterNumber,
    required this.paymentMethod,
    required this.accountNumber,
    required this.billAmount,
    required this.sourceAccount,
  });

  factory BillPaymentsModel.fromJson(Map<String, dynamic> json) {
    return BillPaymentsModel(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      emailAddress: json['emailAddress'] as String,
      meterNumber: json['meterNumber'] as String,
      paymentMethod: json['paymentMethod'] as String,
      accountNumber: json['accountNumber'] as String,
      billAmount: json['billAmount'] as String,
      sourceAccount: json['sourceAccount'] as String,

    );
  }
}
// "billAccount": "BUS0001102",
// "mobileNumber": "263785302628",
// "emailAddress": "kelvin@xplug.co.zw",
// "sourceBank": "NMB",

// "participantReference": "XCOH727313731",
// "channel": "INTERNET", //(ATM, BATCH, INTERNET, MOBILE, POS, OTHER)
// "paymentType": "ACCOUNT", //(ACCOUNT, CASH, CARD, OTHER)
// "paymentMethod": "INTERNAL" //(INTERNAL,ZIPIT,ECOCASH)
// }