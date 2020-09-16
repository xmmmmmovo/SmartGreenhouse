import 'package:auto_route/auto_route.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:smart_green_house_client/common/apis/apis.dart';
import 'package:smart_green_house_client/common/entitys/entitys.dart';
import 'package:smart_green_house_client/common/utils/utils.dart';
import 'package:smart_green_house_client/common/values/values.dart';
import 'package:smart_green_house_client/common/widgets/widgets.dart';

class SearchResult extends StatefulWidget {
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  Widget appBarTitle = new Text(
    "搜词",
    style: TextStyle(
      color: AppColors.primaryText,
      fontFamily: 'gengsha',
      fontSize: duSetFontSize(18.0),
      fontWeight: FontWeight.w600,
    ),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: AppColors.primaryText,
  );
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching;

  bool isPerformingRequest = false;
  List<WordData> _items = [];
  int page = 1;
  int pages = 1;

  void fetchData() async {
    if (!isPerformingRequest && page <= pages) {
      setState(() {
        isPerformingRequest = true;
      });
      var tmp = await getSearchData(
          context: context,
          params: SearchDataRequest(
              page: page, size: 20, word: _searchQuery.value.text));

      setState(() {
        pages = tmp.pages;
        page = tmp.pageNum + 1;
        _items.addAll(tmp.list);
        isPerformingRequest = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: key,
      appBar: buildBar(context),
      body: EasyRefresh.custom(
        header: MaterialHeader(),
        footer: MaterialFooter(),
        onRefresh: () async {
          page = 1;
          pages = 1;
          _items.clear();
          fetchData();
        },
        onLoad: () async {
          fetchData();
        },
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (content, index) {
                return _displayList(index);
              },
              childCount: _items.length,
            ),
          )
        ],
      ),
    );
  }

  Widget _displayList(int index) {
    return Container(
        padding: EdgeInsets.only(left: 2.0, bottom: 2.0, right: 2.0),
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[_Flexible(index)],
              ),
            ),
          ),
          SizedBox(height: duSetHeight(5)),
        ]));
  }

  Widget _Flexible(int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            _items[index].word,
            style: Theme.of(context).textTheme.headline6,
          ),
          Text("翻译:${_items[index].translation}",
              style: TextStyle(color: Colors.grey[600], fontSize: 18.0)),
        ],
      ),
    );
  }

  Widget buildBar(BuildContext context) {
    return transparentAppBar(
        context: context,
        title: appBarTitle,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primaryText,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            onPressed: () {
              setState(() {
                if (this.actionIcon.icon == Icons.search) {
                  this.actionIcon = new Icon(
                    Icons.close,
                    color: AppColors.primaryText,
                  );
                  this.appBarTitle = new TextField(
                    controller: _searchQuery,
                    style: new TextStyle(
                      color: AppColors.primaryText,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search,
                            color: AppColors.primaryText),
                        hintText: "搜索...",
                        hintStyle: new TextStyle(color: AppColors.primaryText)),
                    onSubmitted: (String val) async {
                      EasyDialog(
                              title: Text("请稍等"),
                              description: Text("搜索中"),
                              closeButton: false)
                          .show(context);
                      await fetchData();
                      ExtendedNavigator.rootNavigator.pop();
                    },
                  );
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: AppColors.primaryText,
      );
      this.appBarTitle = new Text(
        "搜索",
        style: TextStyle(
          color: AppColors.primaryText,
          fontFamily: 'gengsha',
          fontSize: duSetFontSize(18.0),
          fontWeight: FontWeight.w600,
        ),
      );
      _searchQuery.clear();
    });
  }
}
