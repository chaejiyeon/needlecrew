
import 'package:needlecrew/screens/main/fixClothes/directInsert.dart';
import 'package:needlecrew/screens/main/fixClothes/fixQuestion.dart';
import 'package:needlecrew/screens/main/fixClothes/fixSelect.dart';
import 'package:needlecrew/widgets/circleLineBtn.dart';
import 'package:needlecrew/widgets/fixClothes/fixClothesAppbar.dart';
import 'package:needlecrew/widgets/fixClothes/footerBtn.dart';
import 'package:needlecrew/widgets/fixClothes/header.dart';
import 'package:needlecrew/widgets/fixClothes/progressbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/product_category.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/widgets/fontStyle.dart';

class ChooseClothes extends StatefulWidget {
  final int parentNum;

  const ChooseClothes({Key? key, this.parentNum = 0}) : super(key: key);

  @override
  State<ChooseClothes> createState() => _ChooseClothesState();
}

List<int> crumbs = [];

class _ChooseClothesState extends State<ChooseClothes>
    with TickerProviderStateMixin {
  int currentPage = 0;
  int currentCategoryId = 0;
  late TabController _tabController;
  String lastCategory = "";

  // get category list
  List<WooProductCategory> categories = [];

  // get product list
  List<WooProduct> products = [];

  // category 가져오기
  Future<List<WooProductCategory>> getCategories() async {
    categories = await wp_api.wooCommerceApi
        .getProductCategories(parent: widget.parentNum);
    _tabController = TabController(length: categories.length, vsync: this);


    return categories;
  }

  // product 가져오기
  Future<bool> getProducts() async {
    products.clear();
    print("currentcategory" + crumbs.toString());
    try {
      products = await wp_api.wooCommerceApi.getProducts(
          category: currentCategoryId == 0
              ? categories.first.id.toString()
              : currentCategoryId.toString());
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    if (widget.parentNum == 0) crumbs.clear();
    crumbs.add(widget.parentNum);
    super.initState();
    getCategories();

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: FixClothesAppBar(
        appbar: AppBar(),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 24, right: 24),
        color: Colors.white,
        child: FutureBuilder(
            future: getCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // progress bar
                    categories.indexWhere((element) => element.name == '기타') !=
                            -1
                        ? ProgressBar(progressImg: "fixProgressbar_2.svg")
                        : ProgressBar(progressImg: "fixProgressbar.svg"),

                    categories.indexWhere((element) => element.name == '기타') !=
                            -1
                        ? Header(
                            title: "수선 선택",
                            subtitle1: "",
                            question: true,
                            btnIcon: "updateIcon.svg",
                            btnText: "직접 입력하기",
                            widget: DirectInsert(),
                            imgPath: "",
                            bottomPadding: 30,
                          )
                        : Header(
                            title: "의류 선택",
                            subtitle1: widget.parentNum == 2261
                                ? "수선하고자 하는 성별의 의류를\n선택해주세요."
                                : "어떤 옷을 수선하고 싶으세요?",
                            question: true,
                            btnIcon: "chatIcon.svg",
                            btnText: "수선 문의하기",
                            widget: FixQuestion(),
                            imgPath: "fixClothes",
                            bottomPadding: 50,
                          ),


                    // category 표시 > 카테고리에 '기타'가 포함되어 있을 경우 해당 상품 gridview로 표시
                    Expanded(
                      child: Container(
                        padding: categories.indexWhere(
                                    (element) => element.name == '기타') !=
                                -1
                            ? EdgeInsets.zero
                            : EdgeInsets.only(
                                bottom: widget.parentNum == 0 ? 0 : 100),
                        child: categories.indexWhere(
                                    (element) => element.name == '기타') !=
                                -1
                            ? Column(
                                children: [
                                  Container(
                                    height: 34,
                                    child: FutureBuilder(
                                      future: getCategories(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return TabBar(
                                            onTap: (index) {
                                              setState(() {
                                                getProducts();
                                                currentPage = index;
                                                currentCategoryId =
                                                    categories[index].id!;
                                                lastCategory = categories[index].name.toString();
                                              });

                                            },
                                            controller: _tabController,
                                            isScrollable: true,
                                            indicatorColor: Colors.transparent,
                                            unselectedLabelColor: Colors.black,
                                            labelColor: Colors.white,
                                            labelPadding: EdgeInsets.all(0),
                                            indicatorPadding: EdgeInsets.zero,
                                            tabs: List.generate(
                                              categories.length,
                                              (index) => CategoryItem(
                                                  categories[index]
                                                      .name
                                                      .toString(),
                                                  index,
                                                  categories[index].id!),
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 29),
                                      child: FutureBuilder(
                                        future: getProducts(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return TabBarView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              controller: _tabController,
                                              children: List.generate(
                                                _tabController.length,
                                                (index) => GridView(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    mainAxisExtent: 184,
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 10,
                                                    crossAxisSpacing: 10,
                                                  ),
                                                  children: List.generate(
                                                      products.length,
                                                      (index) =>
                                                          chooseOptionItem(
                                                              products[index],
                                                              index, products[index].id!, categories.first.id!)),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView(
                                children: List.generate(
                                  categories.length,
                                  (index) => CircleLineBtn(
                                      iswidget: true,
                                      btnText:
                                          categories[index].name.toString(),
                                      fontboxwidth: double.infinity,
                                      bordercolor: HexColor("#d5d5d5"),
                                      fontcolor: Colors.black,
                                      fontsize: "md",
                                      btnIcon: "",
                                      btnColor: Colors.transparent,
                                      widgetName: ChooseClothes(
                                        parentNum: categories[index].id!,
                                      ),
                                      fontboxheight: ""),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
      bottomNavigationBar: widget.parentNum == 0 ? FooterBtn() : null,
      // floatingActionButton: categories.length < 0 ? FloatingNextBtn(page: ChooseDetail(), ischecked: false) : Container(),
    );
  }

  // category 목록
  Widget CategoryItem(String category, int currentpage, int categoryId) {
    return Container(
      padding: EdgeInsets.only(right: 9),
      child: Container(
        alignment: Alignment.center,
        width: 75,
        decoration: BoxDecoration(
          color:
              currentPage == currentpage ? HexColor("#fd9a03") : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            width: 1,
            color: currentPage == currentpage
                ? HexColor("#fd9a03")
                : HexColor("#d5d5d5"),
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 16,
            color:
                currentPage == currentpage ? Colors.white : HexColor("#909090"),
          ),
        ),
      ),
    );
  }

  // gridview 아이템
  Widget chooseOptionItem(WooProduct product, int index, int productId, int categoryId) {
    String imageSrc = "";
    if (product.images.isNotEmpty) imageSrc = product.images.first.src ?? "";

    return GestureDetector(
      onTap: () {
        Get.off(() => FixSelect(productId: productId, crumbs: crumbs, lastCategory: lastCategory == "" ? categories.first.name.toString() : lastCategory,));
      },
      child: Container(
        height: 184,
        decoration: BoxDecoration(
          border: Border.all(
            color: HexColor("#909090").withOpacity(0.5),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: double.infinity,
                height: 100,
                child: (imageSrc != "")
                    ? Image.network(imageSrc)
                    : Image.asset(
                        "assets/images/sample_2.jpeg",
                        fit: BoxFit.cover,
                      )),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FontStyle(
                            text: product.name.toString(),
                            fontsize: "",
                            fontbold: "bold",
                            fontcolor: Colors.black,
                            textdirectionright: false),
                      ),
                      Icon(
                        CupertinoIcons.question_circle,
                        size: 15,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.price.toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text("원"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
