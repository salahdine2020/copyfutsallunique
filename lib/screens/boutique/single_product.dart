import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/common_widgets/custom_app_bar.dart';
import 'package:futsal_unique/common_widgets/shopping_bag.dart';
import 'package:futsal_unique/models/cart_model.dart';
import 'package:futsal_unique/models/product_model.dart';
import 'package:futsal_unique/providers/cart_provider.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatefulWidget {
  final Map<String, dynamic> data;
  final String cat_name;
  const SingleProduct({Key? key,required this.data, required this.cat_name}) : super(key: key);

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {

  int? currentIndexSize;
  int? currentIndexColor;

  String? colorSelected;
  String? sizeSelected;
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: CustomAppBar(),
          actions: [
            ShopBag()
          ],
        ),
        bottomSheet: Material(
          elevation: 18.0,
          child: Container(
                height: 80.0,
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(97, 90, 90, .14),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text((widget.data['percentDiscount'] == 0)
                        ? widget.data['pricePrdct'].toString() + "€"
                      : cart.prdctPriceWithSale.toString() + "€", style: KGraduateTextStyleTitle,),
                    OutlinedButton(
                      onPressed: (sizeSelected == null || colorSelected == null)? () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Veuillez sélectionner la taille et la couleur!", style: textStyleWhite,textAlign: TextAlign.center,),
                          elevation: 8.0,
                          backgroundColor: colorButton,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),));
                      } :() {
                        print('percent discount === ${widget.data['percentDiscount']} --- ${cart.prdctPriceWithSale.toString()}');
                          Cart panier = Cart(
                              cartID: widget.data['productID'],
                              productID: widget.data['productID'],
                              namePrdct: widget.data['namePrdct'],
                              pricePrdct:(widget.data['percentDiscount'] == 0) ? widget.data['pricePrdct'] : cart.prdctPriceWithSale.toString() ,
                              initialPrice: (widget.data['percentDiscount'] == 0) ? widget.data['pricePrdct'] : cart.prdctPriceWithSale.toString() ,
                              qty: 1,
                              colorPrdct: colorSelected,
                              sizePrdct: sizeSelected,
                              imagePrdct: widget.data['imagePrdct'],
                              userID: '');


                          cart.addCart(panier, context);

                      },
                      child: Text("Ajouter Au Panier", style: KLatoTextStyleTextButton.copyWith(color: Colors.black)),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        textStyle: KLatoTextStyleText,
                        side: BorderSide(width: 2.0,color: Colors.black),
                      ),
                    )
                  ],
                )
            ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.data['namePrdct'],
                      style: KGraduatePaiementButtonPriceStyle.copyWith(color: Colors.black)),
                  SizedBox(height: 10,),
                  Text(widget.cat_name,
                    style: TextStyle(color: Color.fromRGBO(97, 90, 90, .54), fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  Center(child: Image.network(widget.data['imagePrdct'])),
                  SizedBox(height: 20,),
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Center(child: Text('Taille',style: TextStyle(color: Color.fromRGBO(97, 90, 90, .54), fontSize: 18, fontWeight: FontWeight.bold),)),
                        SizedBox(width: 30,),
                        getSizesRow(widget.data['sizePrdct'], cart),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        Center(child: Text('Couleurs',style: TextStyle(color: Color.fromRGBO(97, 90, 90, .54), fontSize: 18, fontWeight: FontWeight.bold),)),
                        SizedBox(width: 30,),
                        getColorsRow(widget.data['colorsPrdct'], cart ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50,),
                  Text(widget.data['descriptionPrdct'],
                    style: TextStyle(color: Color.fromRGBO(51, 51, 51, 0.54), height: 1.4, fontSize: 18,),),
                  SizedBox(height: 80,),
                ],
              ),
            )
        )
    );
  }


  Widget getColorsRow(List<dynamic> colors, CartProvider cart){
    {

      ScrollController scrollController = ScrollController();
      return Container(
        height: 50.0,
        child: ListView.separated(
            itemCount: colors.length,
            shrinkWrap: true,
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 5);
            },
            itemBuilder: (BuildContext context, i){
              return InkWell(
                onTap: () {
                  setState(() {
                    currentIndexColor = i;
                    colorSelected = colors[i];
                    print('colors product $i === ${colors[i]} --- $colorSelected');
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      border: (currentIndexColor == i)? Border.all(width: 3, color: colorButton)
                      : Border.all(width: 0.0, color: Colors.white),
                      shape: BoxShape.circle,
                      color: Colors.white
                  ),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(int.parse(colors[i]))
                    ),
                  ),
                ),
              );
            }),
      );
    }
  }

  Widget getSizesRow(List<dynamic> sizes, CartProvider cart) {

    ScrollController scrollController = ScrollController();
      return Container(
        height: 50.0,
        child: ListView.separated(
            itemCount: sizes.length,
            shrinkWrap: true,
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 5);
            },
            itemBuilder: (BuildContext context, i){
              return InkWell(
                  onTap: () {
                    setState(() {
                      currentIndexSize = i;
                      sizeSelected = sizes[i];
                      print('sizes product $i === ${sizes[i]} --- $sizeSelected');
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    //margin: EdgeInsets.symmetric(horizontal:10),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        border: (currentIndexSize == i)? Border.all(width: 3, color: colorButton)
                        : Border.all(width: 0.0, color: Colors.white),
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                    child: Container(
                      width: 30,
                      height: 30,
                      child: Center(child: Text(sizes[i] ,
                        style: TextStyle(color: Color.fromRGBO(97, 90, 90, .54), fontSize: 18, fontWeight: FontWeight.bold),)),
                    ),
                  ),
                );
            }),
      );
    }
}
