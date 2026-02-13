import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pari_enterprises_delivery/model/add_to_cart_model.dart';
import 'package:pari_enterprises_delivery/model/cart_item_model.dart';
import 'package:pari_enterprises_delivery/model/checkout_model.dart';
import 'package:pari_enterprises_delivery/model/drop_request_model.dart';
import 'package:pari_enterprises_delivery/model/laundry_category_model.dart';
import 'package:pari_enterprises_delivery/model/laundry_sub_category_model.dart';
import 'package:pari_enterprises_delivery/model/login_model.dart';
import 'package:pari_enterprises_delivery/model/mark_delivered_response_model.dart';
import 'package:pari_enterprises_delivery/model/order_detail_model.dart';
import 'package:pari_enterprises_delivery/model/order_model.dart';
import 'package:pari_enterprises_delivery/model/pickup_request_model.dart';
import 'package:pari_enterprises_delivery/model/remove_cart_model.dart';
import 'api_config.dart';

class ApiService {
  /// GENERIC POST REQUEST
  static Future<Map<String, dynamic>> _postRequest(
    String url,
    Map<String, String> params,
  ) async {
    try {
      final response = await http.post(Uri.parse(url), body: params);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 1, 'message': 'Server error'};
      }
    } catch (e) {
      return {'status': 1, 'message': 'Network error'};
    }
  }

  /// LOGIN
  static Future<LoginModel?> login({
    required String username,
    required String password,
  }) async {
    final res = await _postRequest(ApiConfig.loginUrl, {
      'username': username,
      'password': password,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return LoginModel.fromJson(res);
    }

    return null;
  }

  /// GET LAUNDRY CATEGORY
  static Future<List<LaundryCategoryModel>> getLaundryCategory() async {
    final res = await _postRequest(
      ApiConfig.getLaundryCategoryUrl,
      {}, // no params
    );

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => LaundryCategoryModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// GET LAUNDRY SUB CATEGORY
  static Future<List<LaundrySubCategoryModel>> getLaundrySubCategory({
    required String laundrySrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getLaundrySubCategoryUrl, {
      'laundry_srno': laundrySrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => LaundrySubCategoryModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// GET PICKUP REQUESTS (DELIVERY)
  static Future<List<PickupRequestModel>> getPickupRequests({
    required String userSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getPickupRequestsUrl, {
      'assigened_to_usersrno': userSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => PickupRequestModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// ADD TO CART
  static Future<AddToCartModel?> addToCart({
    required String laundrySubCategorySrNo,
    required String qty,
    required String assignedToUserSrNo,
    required String userSrNo,
    required String pickupSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.addToCartUrl, {
      'laundry_subcategory_srno': laundrySubCategorySrNo,
      'qty': qty,
      'assigened_to_usersrno': assignedToUserSrNo,
      'usersrno': userSrNo,
      'pickupsrno': pickupSrNo,
    });

    if (res['status'] == 0) {
      return AddToCartModel.fromJson(res);
    }

    return null;
  }

  /// VIEW CART
  static Future<ViewCartResponse?> viewCart({
    required String pickupSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.viewCartUrl, {
      'pickupsrno': pickupSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      final items = (res['data'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList();

      return ViewCartResponse(
        items: items,
        total: double.parse(res['total'].toString()),
      );
    }

    return null;
  }

  /// REMOVE CART ITEM
  static Future<RemoveCartModel?> removeCartItem({
    required String tempSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.removeCartUrl, {
      'tempsrno': tempSrNo,
    });

    if (res['status'] == 0) {
      return RemoveCartModel.fromJson(res);
    }

    return null;
  }

  /// CHECKOUT / PLACE ORDER
  static Future<CheckoutModel?> checkout({
    required String pickupSrNo,
    required String assignedToUserSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.checkoutUrl, {
      'pickupsrno': pickupSrNo,
      'assigened_to_usersrno': assignedToUserSrNo,
    });

    if (res['status'] == 0) {
      return CheckoutModel.fromJson(res);
    }

    return null;
  }

  static Future<List<OrderModel>> getOrdersByPickup({
    required String pickupSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getMyOrdersPickups, {
      "pickupsrno": pickupSrNo,
    });

    if (res['status'] == 0) {
      return (res['data'] as List).map((e) => OrderModel.fromJson(e)).toList();
    }

    return [];
  }

  static Future<List<OrderDetailModel>> getOrderDetails({
    required String orderSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getOrderDetails, {
      "ordersrno": orderSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => OrderDetailModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<List<DropRequestModel>> getDropRequests({
    required String userSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.getDropRequestsUrl, {
      'drop_usersrno': userSrNo,
    });

    if (res['status'] == 0 && res['data'] != null) {
      return (res['data'] as List)
          .map((e) => DropRequestModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<MarkDeliveredResponse?> markAsDelivered({
    required String billSrNo,
  }) async {
    final res = await _postRequest(ApiConfig.markAsDeliveredUrl, {
      'bill_srno': billSrNo,
    });

    if (res['status'] == 0) {
      return MarkDeliveredResponse.fromJson(res);
    }
    return null;
  }
}
