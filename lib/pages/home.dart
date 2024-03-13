import 'package:flutter/material.dart';
import 'package:poetry/pages/play_game.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('古诗接龙',
        ),
        centerTitle: true,
      ),
      body: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/gushi.png', // 替换为你的图片路径
            // fit: BoxFit.cover,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // 在这里添加按钮的点击事件
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => PlayGamePage()),
                  );
              },
              child: const Text('开始游戏'),
            ),
          ),
        ],
      ),
    );
  }
}