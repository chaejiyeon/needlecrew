import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:needlecrew/controller/fix_clothes/fixselect_controller.dart';
import 'package:needlecrew/screens/main/alram_info.dart';
import 'package:needlecrew/screens/main/cart_info.dart';
import 'package:needlecrew/screens/main/fixClothes/direct_insert.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_question.dart';
import 'package:needlecrew/screens/main/fixClothes/fix_select.dart';
import 'package:needlecrew/screens/main/fix_clothes.dart';
import 'package:needlecrew/screens/main_page.dart';
import 'package:needlecrew/widgets/appbar_item.dart';
import 'package:needlecrew/widgets/channeltalk.dart';
import 'package:needlecrew/widgets/circle_line_btn.dart';
import 'package:needlecrew/widgets/custom/custom_appbar.dart';
import 'package:needlecrew/widgets/custom/custom_widgets.dart';
import 'package:needlecrew/widgets/fixClothes/footer_btn.dart';
import 'package:needlecrew/widgets/fixClothes/header.dart';
import 'package:needlecrew/widgets/fixClothes/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_woocommerce_api/flutter_woocommerce_api.dart';
import 'package:flutter_woocommerce_api/models/product_category.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:needlecrew/db/wp-api.dart' as wp_api;
import 'package:needlecrew/widgets/font_style.dart';
import 'package:needlecrew/widgets/tootip_custom.dart';

class ChooseClothes extends StatefulWidget {
  final String selectItem;
  final int parentNum;

  const ChooseClothes({Key? key, this.selectItem = '', this.parentNum = 0})
      : super(key: key);

  @override
  State<ChooseClothes> createState() => _ChooseClothesState();
}

class _ChooseClothesState extends State<ChooseClothes>
    with TickerProviderStateMixin {
  final FixSelectController controller = Get.put(FixSelectController());

  // 현재 페이지
  int currentPage = 0;

  // 현재 카테고리 id
  int currentCategoryId = 0;

  // tab controller
  late TabController _tabController;

  // 마지막 카테고리
  String lastCategory = "";

  // get category list
  List<WooProductCategory> categories = [];

  // get product list
  List<WooProduct> products = [];

  // category 가져오기
  Future<List<WooProductCategory>> getCategories() async {
    print("this parent id info  !!!!!!" + widget.parentNum.toString());
    categories = await wp_api.wooCommerceApi
        .getProductCategories(parent: widget.parentNum, order: 'desc');
    _tabController = TabController(length: categories.length, vsync: this);

    return categories;
  }

  // product 가져오기
  Future<bool> getProducts() async {
    products.clear();
    print("currentcategory" + controller.crumbs.toString());
    try {
      products = await wp_api.wooCommerceApi.getProducts(
          perPage: 100,
          // orderBy: 'slug',
          category: currentCategoryId == 0
              ? categories.first.id.toString()
              : currentCategoryId.toString());

      // 카탈로그 가시성 - 숨겨짐일 경우 제품 항목에서 제외
      for (int i = 0; i < products.length; i++) {
        if (products[i].catalogVisibility == 'hidden') {
          products.removeAt(i);
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    printInfo(
        info: 'select fix clothes info this ${controller.fixClothesInfo}');

    if (widget.parentNum == 0) {
      controller.selectSize.value = 0;
      controller.fixClothesInfo.clear();
      controller.crumbs.clear();
    }

    // back 버튼 클릭하지 않았을 때에만 crumbs에 add
    if (controller.backClick == false) {
      controller.crumbs.add(widget.parentNum);
    }

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
      appBar: CustomAppbar(
        leadingWidget: BackBtn(backFt: () {
          if (controller.crumbs.length == 0)
            Get.to(FixClothes());
          else {
            controller.backClick.value = true;

            // back버튼 클릭시 crumbs 마지막 카테고리 Id remove
            if (controller.crumbs.length > 0) {
              controller.crumbs.removeLast();
              controller.fixClothesInfo.removeLast();
            }

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ChooseClothes(
                          parentNum: controller.crumbs.length > 0
                              ? controller.crumbs.last
                              : 0,
                        )));
          }
        }),
        appbarcolor: 'white',
        appbar: AppBar(),
        actionItems: [
          AppbarItem(
            icon: 'homeIcon.svg',
            iconColor: Colors.black,
            iconFilename: 'main',
            widget: MainPage(pageNum: 0),
          ),
          AppbarItem(
            icon: 'cartIcon.svg',
            iconColor: Colors.black,
            iconFilename: 'main',
            widget: CartInfo(),
          ),
          AppbarItem(
            icon: 'alramIcon.svg',
            iconColor: Colors.black,
            iconFilename: 'main',
            widget: AlramInfo(),
          ),
        ],
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
                            btnText: '',
                            // btnText: "수선 문의하기",
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
                                                lastCategory = categories[index]
                                                    .name
                                                    .toString();
                                              });
                                            },
                                            controller: _tabController,
                                            // isScrollable: true,
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
                                                    mainAxisExtent: 270,
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 5,
                                                    crossAxisSpacing: 10,
                                                  ),
                                                  children: List.generate(
                                                      products.length,
                                                      (index) =>
                                                          chooseOptionItem(
                                                              products[index],
                                                              index,
                                                              products[index]
                                                                  .id!,
                                                              categories
                                                                  .first.id!)),
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
                                      btnFt: () {
                                        controller.fixClothesInfo.add(
                                            categories[index].name.toString());
                                      },
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
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.only(bottom: 6),
        alignment: Alignment.center,
        width: 75,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: currentPage == currentpage ? 2 : 1,
          color: currentPage == currentpage
              ? HexColor("#fd9a03")
              : HexColor("#d5d5d5"),
        ))),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 16,
            color: currentPage == currentpage
                ? HexColor("#fd9a03")
                : HexColor("#707070"),
          ),
        ),
      ),
    );
  }

  // gridview 아이템
  Widget chooseOptionItem(
      WooProduct product, int index, int productId, int categoryId) {
    String imageSrc = "";
    if (product.images.isNotEmpty) imageSrc = product.images.first.src ?? "";

    return Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (product.name.toString() == "복원수선") {
                Get.to(Channeltalk());
              } else {
                Get.to(() => FixSelect(
                      productId: productId,
                      crumbs: controller.crumbs,
                      lastCategory: lastCategory == ""
                          ? categories.first.name.toString()
                          : lastCategory,
                    ));
              }
            },
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: HexColor("#d5d5d5"),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                height: (MediaQuery.of(context).size.width - 58) * 0.5,
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: (imageSrc != "")
                      ? Image.network(imageSrc)
                      : Image.asset(
                          "assets/images/sample_2.jpeg",
                          fit: BoxFit.cover,
                        ),
                )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TooltipCustom(
                    tooltipText: product.shortDescription.toString(),
                    titleText: product.name.toString(),
                    boldText: []),
                Expanded(
                  child: product.price.toString() == "0"
                      ? ontapWidget(
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text("직접문의")),
                          product,
                          productId)
                      : ontapWidget(
                          Align(
                            alignment: Alignment.topLeft,
                            child: EasyRichText(
                              product.price.toString() + "원",
                              textAlign: TextAlign.start,
                              patternList: [
                                EasyRichTextPattern(
                                    targetString: product.price.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'NotoSansCJKkrMedium')),
                                EasyRichTextPattern(
                                    targetString: "원",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          product,
                          productId),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // widget에 ontap 기능 추가
  Widget ontapWidget(Widget widget, WooProduct product, int productId) {
    return GestureDetector(
      onTap: () {
        if (product.name.toString() == "복원수선") {
          Get.to(Channeltalk());
        } else {
          Get.to(() => FixSelect(
                productId: productId,
                crumbs: controller.crumbs,
                lastCategory: lastCategory == ""
                    ? categories.first.name.toString()
                    : lastCategory,
              ));
        }
      },
      child: widget,
    );
  }
}
