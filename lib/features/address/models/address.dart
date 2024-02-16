class Address {
  final String postalCode;
  final String street;
  final String number;
  // final String? county;
  final String city;
  final String? state;
  final String country;
  final String? complement;

  Address({
    required this.postalCode,
    required this.street,
    required this.number,
    // required this.county,
    required this.city,
    required this.state,
    required this.country,
    this.complement,
  });

  static Address fromMap(Map<String, dynamic> map) {
    return Address(
      postalCode: map['postalCode'],
      street: map['street'],
      number: map['number'],
      // county: map['county'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      complement: map['complement'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postalCode': postalCode,
      'street': street,
      'number': number,
      // 'county': county,
      'city': city,
      'state': state,
      'country': country,
      'complement': complement,
    };
  }
}
