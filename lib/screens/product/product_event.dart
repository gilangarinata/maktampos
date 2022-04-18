import 'package:equatable/equatable.dart';
import 'package:pos_admin/services/param/category_param.dart';
import 'package:pos_admin/services/param/inventory_param.dart';
import 'package:pos_admin/services/param/product_param.dart';

abstract class ProductEvent extends Equatable {}

class GetProducts extends ProductEvent {
  @override
  List<Object> get props => [];

  GetProducts();
}

class GetSubcategories extends ProductEvent {
  @override
  List<Object> get props => [];

  GetSubcategories();
}

class CreateProduct extends ProductEvent {
  ProductParam productParam;

  @override
  List<Object> get props => [];

  CreateProduct(this.productParam);
}

class UpdateProduct extends ProductEvent {
  ProductParam productParam;

  @override
  List<Object> get props => [];

  UpdateProduct(this.productParam);
}

class DeleteProduct extends ProductEvent {
  int id;

  @override
  List<Object> get props => [];

  DeleteProduct(this.id);
}

class GetCategories extends ProductEvent {
  @override
  List<Object> get props => [];

  GetCategories();
}

class CreateCategory extends ProductEvent {
  CategoryParam param;
  @override
  List<Object> get props => [param];

  CreateCategory(this.param);
}

class UpdateCategory extends ProductEvent {
  CategoryParam param;
  @override
  List<Object> get props => [param];

  UpdateCategory(this.param);
}

class DeleteCategory extends ProductEvent {
  int id;
  @override
  List<Object> get props => [id];

  DeleteCategory(this.id);
}


