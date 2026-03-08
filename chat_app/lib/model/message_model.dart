class MessageModel {
  String senderEmail;
  String message;

  MessageModel({required this.senderEmail, required this.message});

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(
      senderEmail: jsonData['senderEmail'] ?? "",
      message: jsonData['message'] ?? "",
    );
  }
}
