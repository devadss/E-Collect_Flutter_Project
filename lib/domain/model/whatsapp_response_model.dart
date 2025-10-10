import 'dart:convert';

class WhatsAppApiResponse {
  final bool success;
  final WhatsAppResponse response;

  WhatsAppApiResponse({required this.success, required this.response});

  factory WhatsAppApiResponse.fromJson(Map<String, dynamic> json) {
    return WhatsAppApiResponse(
      success: json['success'],
      response: WhatsAppResponse.fromJson(jsonDecode(json['response'])),
    );
  }
}

class WhatsAppResponse {
  final String messagingProduct;
  final List<Contact> contacts;
  final List<Message> messages;

  WhatsAppResponse({
    required this.messagingProduct,
    required this.contacts,
    required this.messages,
  });

  factory WhatsAppResponse.fromJson(Map<String, dynamic> json) {
    return WhatsAppResponse(
      messagingProduct: json['messaging_product'],
      contacts: (json['contacts'] as List)
          .map((e) => Contact.fromJson(e))
          .toList(),
      messages: (json['messages'] as List)
          .map((e) => Message.fromJson(e))
          .toList(),
    );
  }
}

class Contact {
  final String input;
  final String waId;

  Contact({required this.input, required this.waId});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      input: json['input'],
      waId: json['wa_id'],
    );
  }
}

class Message {
  final String id;

  Message({required this.id});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
    );
  }
}
