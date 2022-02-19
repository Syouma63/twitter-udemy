import 'package:flutter/material.dart';
import 'package:twitter/view/time_line/post_page.dart';
import 'package:twitter/view/time_line/time_line_page.dart';

import 'account/account_page.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  // ページの番号
  int selectIndex = 0;
  // リストに表示したいページを格納
  List<Widget> pageList = [TimeLinePage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ページリストの番号のページを表示
      body: pageList[selectIndex],
      // ボトムナビゲーションバー
      bottomNavigationBar: BottomNavigationBar(
        // アイコンとラベル　※ラベルを書かないとエラーが出る
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity_outlined),
              label: ''
          ),
        ],
        currentIndex: selectIndex,
        // タップしたら表示したいページが表示する
        onTap: (index) {
          setState(() {
            selectIndex = index;
          });
        },
      ),
      // 投稿ページに遷移する右下の青いアイコン
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage()));
          },
          child: Icon(Icons.chat_bubble_outline)
      ),
    );
  }
}
