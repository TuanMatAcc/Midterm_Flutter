class AppUser {
  String fullName;
  String email;
  String shippingAddress;
  int loyaltyPoints = 0;

  AppUser({
    required this.email,
    required this.fullName,
    required this.shippingAddress,
    loyaltyPoints = 0,
  }) {
    if(fullName.isEmpty) {
      throw ArgumentError("Full name must not be blank");
    }
    if(email.isEmpty) {
      throw ArgumentError("Email must not be blank");
    }
    if(shippingAddress.isEmpty) {
      throw ArgumentError("Shipping address must not be blank");
    }
    if(loyaltyPoints < 0) {
      throw ArgumentError("Points couldn't be negative");
    }
  }

  // factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
  //   return AppUser(
  //     email: data['email'] ?? '',
  //     fullName: data['fullName'] ?? '',
  //     loyaltyPoints: data['loyaltyPoints'] ?? 0,
  //   );
  // }
}