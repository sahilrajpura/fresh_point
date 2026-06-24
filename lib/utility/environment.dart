class Environment {
  static const bool production = true;

  static const String baseUrl = 'https://freshmart.emaad-infotech.com/';

  static const String villageList = '${baseUrl}common_request_api/village_data';
  static const String areaList = '${baseUrl}common_request_api/area_data';
  static const String register = '${baseUrl}user_api/register';
  static const String login = '${baseUrl}user_api/login';
  static const String userProfile = '${baseUrl}user_api/profile';
  static const String productList = '${baseUrl}product_api/search_product';
  static const String policy = '${baseUrl}common_request_api/get_cms';
  static const String siteData = '${baseUrl}common_request_api/get_site_data';
  static const String productDetail = '${baseUrl}product_api/product_detail';
  static const String addToCart = '${baseUrl}user_api/add_cart_product';
  static const String removeCart = '${baseUrl}user_api/remove_cart_product';
  static const String getCart = '${baseUrl}user_api/get_cart_product';
  static const String makeOrder = '${baseUrl}user_api/make_order';
  static const String getOrders = '${baseUrl}user_api/get_order_list';
  static const String orderDetail = '${baseUrl}user_api/order_detail';
  static const String searchProduct = '${baseUrl}product_api/search_product';
  static const String deliveryboy = '${baseUrl}user_api/get_order_list_delivery';
  static const String offerList = '${baseUrl}user_api/get_offer_list';

  // Android Version Code (Force Update) Old 45
  static const int ANDROID_VERSION_CODE = 46;

  // IOS Version Code (Force Update) Old 28
  static const int IOS_VERSION_CODE = 29;
}
