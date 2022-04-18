import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_admin/components/progress_loading.dart';
import 'package:pos_admin/extensions.dart';
import 'package:pos_admin/res/my_colors.dart';
import 'package:pos_admin/screens/product/product_event.dart';
import 'package:pos_admin/screens/product/product_state.dart';
import 'package:pos_admin/services/param/product_param.dart';
import 'package:pos_admin/services/responses/subcategory_response.dart';
import 'package:pos_admin/services/responses/product_response.dart';
import 'package:pos_admin/utils/my_snackbar.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:collection/collection.dart';


import '../../../constants.dart';
import '../product_bloc.dart';

class CreateProductDialog extends StatefulWidget {
  const CreateProductDialog({Key? key, required this.categoryItems, this.productItem}) : super(key: key);


  final List<SubcategoryItem> categoryItems;
  final ProductItem? productItem;

  @override
  State<CreateProductDialog> createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {

  SubcategoryItem? _selectedItems;
  late TextEditingController _categoryController;
  late TextEditingController _nameController;
  late TextEditingController _priceListController;
  bool _createProductLoading = false;
  bool _deleteProductLoading = false;
  bool? nameIsValid;
  bool? priceIsValid;
  bool? categoryIsValid;

  late ProductBloc bloc;

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.categoryItems.firstWhereOrNull((element) => element.id == widget.productItem?.subcategoryId);
    _categoryController = TextEditingController(text: _selectedItems?.categoryName);
    _nameController = TextEditingController(text: widget.productItem?.name);
    _priceListController = TextEditingController(text : widget.productItem?.price?.toString());

    bloc = BlocProvider.of<ProductBloc>(context);
  }

  void blocListener(BuildContext context, ProductState state) async {
    if (state is CreateProductLoading) {
      setState(() {
        _createProductLoading = true;
      });
    }else if (state is DeleteProductLoading) {
      setState(() {
        _deleteProductLoading = true;
      });
    }  else if (state is CreateProductSuccess) {
      /*
        create product
       */
      setState(() {
        _createProductLoading = false;
        _deleteProductLoading = false;
      });
      Navigator.pop(context);
    }   else if (state is InitialState) {
      setState(() {
        _createProductLoading = false;
        _deleteProductLoading = false;
      });
    } else if (state is FailedState) {
      Navigator.of(context).pop();
      setState(() {
        _createProductLoading = false;
        _deleteProductLoading = false;
      });
      if (state.code == 401) {
        MySnackbar(context)
            .errorSnackbar("Sesi anda habis, silahkan login ulang");
        // ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
        return;
      }
      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var categoryDialog = AlertDialog(
        title: Text("Select one country"),
        content: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.categoryItems
                  .map((e) => RadioListTile(
                title: Text(e.categoryName ?? ""),
                value: e,
                groupValue: _selectedItems,
                selected: _selectedItems == e,
                onChanged: (value) {
                  if (value != _selectedItems) {
                    setState(() {
                      _selectedItems = value as SubcategoryItem;
                    });
                    _categoryController.text = _selectedItems?.categoryName ?? "";
                    Navigator.of(context).pop();
                  }
                },
              ))
                  .toList(),
            ),
          ),
        ));
    return BlocListener<ProductBloc, ProductState>(
      listener: blocListener,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Tambah Produk",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 16
                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close))
              ],
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  nameIsValid = value.isNotEmpty;
                });
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Nama Produk",
                filled: true,
                errorText: nameIsValid == false ? "Tidak Boleh Kosong" : null,
                fillColor: Colors.transparent,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // borderSide: BorderSide.,
                ),
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _priceListController,
              onChanged: (value) {
                setState(() {
                  priceIsValid = value.isNotEmpty;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: priceIsValid == false ? "Tidak Boleh Kosong" : null,
                hintText: "Harga",
                fillColor: Colors.transparent,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // borderSide: BorderSide.,
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                showDialog<void>(context: context, builder: (context) => categoryDialog);
              },
              child: TextField(
                controller: _categoryController,
                enabled: false,
                onChanged: (value) {
                  setState(() {
                    categoryIsValid = value.isNotEmpty;
                  });
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  errorText: categoryIsValid == false ? "Tidak Boleh Kosong" : null,
                  hintText: "Kategori",
                  filled: true,
                  fillColor: Colors.transparent,
                  hintStyle: TextStyle(color: MyColors.grey_60),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // borderSide: BorderSide.,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // borderSide: BorderSide.,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              child: _createProductLoading ? ProgressLoading() : FlatButton.icon(
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kPrimaryColor,
                onPressed: () {
                  var productName = _nameController.text.toString();
                  var price = int.tryParse(_priceListController.text.toString());
                  var subcategoryId = _selectedItems?.id;
                  if(productName.isEmpty){
                    setState(() {
                      nameIsValid = false;
                    });
                    return;
                  }
                  if(price == null){
                    setState(() {
                      priceIsValid = false;
                    });
                    return;
                  }
                  if(subcategoryId == null){
                    setState(() {
                      categoryIsValid = false;
                    });
                    return;
                  }
                  setState(() {
                    priceIsValid = true;
                    categoryIsValid = true;
                    nameIsValid = true;
                  });
                  var productParam = ProductParam(productName, subcategoryId, price, widget.productItem?.id);
                  if(productParam.isValid()){
                    if(widget.productItem != null){
                      bloc.add(UpdateProduct(productParam));
                    }else{
                      bloc.add(CreateProduct(productParam));
                    }
                  }
                },
                icon: WebsafeSvg.asset("assets/Icons/Edit.svg", width: 16),
                label: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white),
                ),
              ).addNeumorphism(
                topShadowColor: Colors.white,
                bottomShadowColor: const Color(0xFF234395).withOpacity(0.2),
              ),
            ),
            if(widget.productItem != null)
              _deleteProductLoading ? ProgressLoading() : Container(
                child: _createProductLoading ? ProgressLoading() : FlatButton.icon(
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    showDeleteDialog(context);
                  },
                  label: const Text(
                    "Hapus",
                    style: TextStyle(color: Colors.white),
                  ), icon: Icon(Icons.remove_circle_outline, color: Colors.white,),
                )
              ),
          ],
        ),
      ),
    );
  }

  showDeleteDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Batal"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Hapus"),
      onPressed:  () {
        var productId = widget.productItem?.id;
        if(productId != null){
          bloc.add(DeleteProduct(productId));
        }
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Peringatan"),
      content: Text("Anda yakin ingin mengahpus produk ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

