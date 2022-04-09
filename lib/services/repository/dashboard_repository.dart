import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pos_admin/services/responses/login_response.dart';
import 'package:pos_admin/services/responses/product_response.dart';
import 'package:pos_admin/services/responses/selling_response.dart';
import 'package:pos_admin/services/responses/summary_response.dart';
import 'package:pos_admin/services/param/login_param.dart';
import 'package:collection/collection.dart';
import '../constant.dart';
import '../network_exception.dart';


abstract class DashboardRepository {
  Future<SummaryResponse?> getSummary(String date);
  Future<List<ProductItem>> getSellings(String date);
}

class DashboardRepositoryImpl extends DashboardRepository {
  final Dio _dioClient;

  DashboardRepositoryImpl(this._dioClient);

  @override
  Future<SummaryResponse?> getSummary(String date) async {
    try {
      final response = await _dioClient.get(Constant.summary,
          queryParameters: {
            "date" : date
          },);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return SummaryResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

    /*
        First get the list of product in this func
        Then get Selling data in sellingData() method
     */
  @override
  Future<List<ProductItem>> getSellings(String date) async {
    try {
      final response = await _dioClient.get(Constant.products,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {

        var productResponse = ProductResponse.fromJson(response.data)
            .items
            ?.where((element) => element.type == Type.ITEM).toList();
        return await getSellingData(date, productResponse);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      print("gilang" + statusMessage);
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  /*
      First get the list of product on getSellings() method
      Then get Selling data in this method
   */
  Future<List<ProductItem>> getSellingData(String date, List<ProductItem>? productItems) async {
    try {
      final response = await _dioClient.get(Constant.selling,
        queryParameters: {
          "date" : date
        },);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var sellingResponse = SellingResponse.fromJson(response.data);
        productItems?.forEach((product) {
          var selling = sellingResponse.items?.firstWhereOrNull((selling) => selling.itemId == product.id);
          if(selling != null){
            product.sold = selling.sold;
          }else{
            product.sold == "0";
          }
        });

        return productItems ?? [];
      } else {
        print("get selling failed");
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }
}