import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_admin/models/Email.dart';
import 'package:pos_admin/res/my_colors.dart';
import 'package:pos_admin/services/responses/product_response.dart';
import 'package:pos_admin/utils/number_utils.dart';
import 'package:pos_admin/utils/screen_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../../constants.dart';
import '../../../extensions.dart';
import '../../pdf_viewer.dart';

class SellingCard extends StatelessWidget {
  const SellingCard({
    Key? key, this.press, required this.productResponse
  }) : super(key: key);

  final VoidCallback? press;
  final List<ProductItem> productResponse;

  Widget buildTableHeader(BuildContext context){
    return Column(
      children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Data Penjualan",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_90,
                        fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Produk",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Kategori",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Penjualan",
                    style: Theme.of(context).textTheme.caption?.copyWith(
                        color: MyColors.grey_80,
                        fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 30,),
      ],
    );
  }

  List<Widget> generateSellingWidget(BuildContext context){
    List<Widget> sellingItems = productResponse.map((selling) => Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                selling.name  ?? "",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_80,
                    fontSize: 14
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                selling.categoryName  ?? "",
                style: Theme.of(context).textTheme.caption?.copyWith(
                    color: MyColors.grey_80,
                    fontSize: 14
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  selling.sold ?? "0",
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: MyColors.grey_80,
                      fontSize: 14
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 30,),
      ],
    )).toList() ?? [];

    sellingItems.insert(0,buildTableHeader(context));
    return sellingItems;
  }

  @override
  Widget build(BuildContext context) {
    //  Here the shadow is not showing properly
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 4),
      child: InkWell(
        onTap: press,
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            color: kBgLightColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            child: Column(
              children: generateSellingWidget(context),
            ),
          ),
        ).addNeumorphism(
          blurRadius: 15,
          borderRadius: 15,
          offset: const Offset(5, 5),
          topShadowColor: Colors.white60,
          bottomShadowColor: const Color(0xFF234395).withOpacity(0.15),
        ),
      ),
    );
  }
}
