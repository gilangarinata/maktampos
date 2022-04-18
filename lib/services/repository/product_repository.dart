import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pos_admin/res/var_constants.dart';
import 'package:pos_admin/services/param/category_param.dart';
import 'package:pos_admin/services/param/inventory_param.dart';
import 'package:pos_admin/services/param/product_param.dart';
import 'package:pos_admin/services/responses/base_response.dart';
import 'package:pos_admin/services/responses/category_response.dart';
import 'package:pos_admin/services/responses/subcategory_response.dart';
import 'package:pos_admin/services/responses/inventory_response.dart';
import 'package:pos_admin/services/responses/login_response.dart';
import 'package:pos_admin/services/responses/material_item_response.dart';
import 'package:pos_admin/services/responses/material_response.dart';
import 'package:pos_admin/services/responses/product_response.dart';
import 'package:pos_admin/services/responses/selling_response.dart';
import 'package:pos_admin/services/responses/stock_response.dart';
import 'package:pos_admin/services/responses/summary_response.dart';
import 'package:collection/collection.dart';
import 'package:pos_admin/services/param/login_param.dart';
import 'package:collection/collection.dart';
import '../constant.dart';
import '../network_exception.dart';


abstract class ProductRepository {
  Future<List<ProductItem>?> getProducts();
  Future<List<SubcategoryItem>?> getSubcategories();
  Future<bool> createProduct(ProductParam param);
  Future<bool> updateProduct(ProductParam param);
  Future<bool> deleteProduct(int id);

  Future<List<CategoryItem>?> getCategories();
  Future<bool> createCategory(CategoryParam param);
  Future<bool> deleteCategory(int id);
  Future<bool> updateCategory(CategoryParam param);
}

class ProductRepositoryImpl extends ProductRepository {
  final Dio _dioClient;


  ProductRepositoryImpl(this._dioClient);

  @override
  Future<List<ProductItem>?> getProducts() async {
    try {
      final response = await _dioClient.get(Constant.products,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {

        var productResponse = ProductResponse.fromJson(response.data)
            .items
            ?.where((element) => element.type == Type.ITEM).toList();
        return productResponse;
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

  @override
  Future<List<SubcategoryItem>?> getSubcategories() async {
    try {
      final response = await _dioClient.get(Constant.subcategory,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var categoryResponse = SubcategoryResponse.fromJson(response.data).items?.where((element) => element.type == "item").toList();
        return categoryResponse;
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

  @override
  Future<bool> createProduct(ProductParam param) async {
    try {
      final response = await _dioClient.post(Constant.products,data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var isSuccess = BaseResponse.fromJson(response.data).success;
        return isSuccess ?? false;
      } else {
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

  @override
  Future<bool> updateProduct(ProductParam param) async {
    try {
      final response = await _dioClient.put(Constant.products,data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var isSuccess = BaseResponse.fromJson(response.data).success;
        return isSuccess ?? false;
      } else {
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

  @override
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _dioClient.delete(Constant.products,queryParameters: {
        "id" : id
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var isSuccess = BaseResponse.fromJson(response.data).success;
        return isSuccess ?? false;
      } else {
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

  @override
  Future<List<CategoryItem>?> getCategories() async {
    try {
      final response = await _dioClient.get(Constant.category,);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var categoryResponse = CategoryResponse.fromJson(response.data).items?.where((element) => element.type == "item").toList();
        return categoryResponse;
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

  @override
  Future<bool> createCategory(CategoryParam param) async {
    try {
      final response = await _dioClient.post(Constant.category,data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        List<CategoryItem>? categories = await getCategories();
        var newCategory = categories?.firstWhereOrNull((element) => element.name == param.name && element.type == param.type);
        return await createSubCategory(param, newCategory);
      } else {
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

  Future<bool> createSubCategory(CategoryParam param, CategoryItem? item) async {
    try {
      var subCategoryParam = {
        "categoryId" : item?.id,
        "name" : param.name,
        "type" : param.type
      };
      final response = await _dioClient.post(Constant.subcategory,data: subCategoryParam);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var isSuccess = BaseResponse.fromJson(response.data).success;
        return isSuccess ?? false;
      } else {
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

  @override
  Future<bool> deleteCategory(int id) async {
    try {
      final response = await _dioClient.delete(Constant.category,queryParameters: {
        "id" : id
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var isSuccess = BaseResponse.fromJson(response.data).success;
        return isSuccess ?? false;
      } else {
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

  @override
  Future<bool> updateCategory(CategoryParam param) async {
    try {
      final response = await _dioClient.put(Constant.category,data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        List<SubcategoryItem>? subcategories = await getSubcategories();
        var subcategoryShouldEdit = subcategories?.firstWhereOrNull((element) => element.subCategoryName == param.previousName);
        return await updateSubCategory(param, subcategoryShouldEdit);
      } else {
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

  Future<bool> updateSubCategory(CategoryParam param, SubcategoryItem? item) async {
    try {
      var subCategoryParam = {
        "subCategoryName" : param.name,
        "id" : item?.id
      };
      final response = await _dioClient.put(Constant.subcategory,data: subCategoryParam);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var isSuccess = BaseResponse.fromJson(response.data).success;
        return isSuccess ?? false;
      } else {
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
