import 'package:red_leaf/Utils/WooCommerceApi/woocommerce_request_util.dart';

class wDataApi {

  Future<wApiResult> products(String per_page, String order, String orderby) async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {
        'per_page' : per_page,
        'order' : order,
        'orderby' : orderby,
      },
      webMethod: 'products',
      RequestType: 'get',
    );
  }

  Future<wApiResult> customers(String per_page) async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {
        'per_page' : per_page,
      },
      webMethod: 'customers',
      RequestType: 'get',
    );
  }

  Future<wApiResult> getCustomer(String id) async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {

      },
      webMethod: 'customers/'+id,
      RequestType: 'get',
    );
  }

  Future<wApiResult> myOrders() async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {
      },
      webMethod: 'orders',
      RequestType: 'get',
    );

  }

  Future<wApiResult> customerOrders(String customerId) async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {
        'customer' : customerId
      },
      webMethod: 'orders',
      RequestType: 'get',
    );

  }
  Future<wApiResult> orders(String per_page, String status) async {

      if(status == "all") {
        return WooCommerceUtil.instance.wooCommerceRequest(
          params: {
            'per_page': per_page,
          },
          webMethod: 'orders',
          RequestType: 'get',
        );
      }
      return WooCommerceUtil.instance.wooCommerceRequest(
          params: {
            'per_page': per_page,
            'status': status,
          },
          webMethod: 'orders',
          RequestType: 'get',
        );

  }

  Future<wApiResult> changeOrderStatus(String id, String status) async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      body: {
          'status' : status
      },
      params: {

      },
      webMethod: 'orders/'+id,
      RequestType: 'put',
    );
  }

  Future<wApiResult> singleOrder(String id) async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {

      },
      webMethod: 'orders/'+id,
      RequestType: 'get',
    );
  }


  Future<wApiResult> salesReportRange(String? period) async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {
        "period" : period
      },
      webMethod: 'reports/sales',
      RequestType: 'get',
    );
  }

  Future<wApiResult> salesReport() async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {},
      webMethod: 'reports/sales',
      RequestType: 'get',
    );
  }

  Future<wApiResult> orderReport() async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {},
      webMethod: 'reports/orders/totals',
      RequestType: 'get',
    );
  }

  Future<wApiResult> productsReport() async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {},
      webMethod: 'reports/products/totals',
      RequestType: 'get',
    );
  }

  Future<wApiResult> topSellerReport(String? period) async {
    return WooCommerceUtil.instance.wooCommerceRequest(
      params: {
        "period" : period
      },
      webMethod: 'reports/top_sellers',
      RequestType: 'get',
    );
  }

}