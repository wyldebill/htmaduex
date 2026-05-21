class Business {
  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.owner,
    required this.phone,
    required this.website,
    required this.hours,
    required this.latitude,
    required this.longitude,
    required this.storefrontImage,
  });

  final int id;
  final String name;
  final String category;
  final String addressLine1;
  final String city;
  final String state;
  final String postalCode;
  final String? owner;
  final String? phone;
  final String? website;
  final String? hours;
  final double latitude;
  final double longitude;
  final String storefrontImage;

  factory Business.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> address =
        (json['address'] as Map<String, dynamic>? ?? <String, dynamic>{});
    final Map<String, dynamic> location =
        (json['location'] as Map<String, dynamic>? ?? <String, dynamic>{});
    return Business(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? 'Unknown business',
      category: json['category'] as String? ?? 'business',
      addressLine1: address['line1'] as String? ?? 'Buffalo, MN',
      city: address['city'] as String? ?? 'Buffalo',
      state: address['state'] as String? ?? 'MN',
      postalCode: address['postalCode'] as String? ?? '',
      owner: json['owner'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      hours: json['hours'] as String?,
      latitude: (location['lat'] as num?)?.toDouble() ?? 45.1719,
      longitude: (location['lng'] as num?)?.toDouble() ?? -93.8747,
      storefrontImage: json['storefrontImage'] as String? ?? '',
    );
  }

  String get address => '$addressLine1, $city, $state';

  String get categoryLabel {
    final String value = category.toLowerCase();
    if (value.contains('cafe') || value.contains('coffee')) return 'Cafes';
    if (value.contains('restaurant') ||
        value.contains('bar') ||
        value.contains('food') ||
        value.contains('fast_food')) {
      return 'Food';
    }
    if (value.contains('hair') ||
        value.contains('bank') ||
        value.contains('clinic') ||
        value.contains('dentist') ||
        value.contains('library') ||
        value.contains('repair')) {
      return 'Services';
    }
    return 'Shops';
  }

  String get storefrontFallback =>
      'https://cdn.pixabay.com/photo/2013/07/12/13/57/shop-147483_1280.png';
}
