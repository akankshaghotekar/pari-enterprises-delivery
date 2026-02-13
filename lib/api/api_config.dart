class ApiConfig {
  static const String baseUrl =
      "https://digitalspaceinc.com/pari_enterprises/ws/";

  static String get loginUrl => "${baseUrl}login.php";
  static String get getLaundryCategoryUrl => "${baseUrl}getLaundryCategory.php";
  static String get getLaundrySubCategoryUrl =>
      "${baseUrl}getLaundrySubCategory.php";
  static String get getPickupRequestsUrl => "${baseUrl}getPickUpRequests.php";
  static String get addToCartUrl => "${baseUrl}addToCart.php";
  static String get viewCartUrl => "${baseUrl}viewCart.php";
  static String get removeCartUrl => "${baseUrl}removecart.php";
  static String get checkoutUrl => "${baseUrl}checkout.php";
  static String get getMyOrdersPickups => "${baseUrl}getmyorders_pickups.php";
  static String get getOrderDetails => "${baseUrl}getorderdetails.php";
  static String get getDropRequestsUrl => "${baseUrl}getDropRequests.php";
  static String get markAsDeliveredUrl => "${baseUrl}markAsDelivered.php";
}
