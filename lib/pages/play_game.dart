import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:voice_to_text/voice_to_text.dart';

class PlayGamePage extends StatefulWidget {
  const PlayGamePage({Key? key}) : super(key: key);

  @override
  _PlayGamePageState createState() => _PlayGamePageState();
}

class _PlayGamePageState extends State<PlayGamePage> {
  String quest = "";
  String answer = "";
  bool answerNext = true;
  String? _selectedOption;
  // 定义一个string类型的数组，用于存放选项
  List<String> options = [];
  final TextEditingController _controller = TextEditingController();
  // final VoiceToText _speech = VoiceToText();
  // bool _isListening = false;
  String text = "";
  String meta = "";

  @override
  void initState() {
    super.initState();
    // _speech.initSpeech();
    // _speech.addListener(() {
    //   setState(() {
    //     text = _speech.speechResult;
    //   });
    // });
    fetchPoem();
  }

  fetchPoem() async {
    final response = await http.get(
      Uri.parse('http://8.141.3.144:3000/api/poetry/quiz'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      
      final data = json.decode(response.body);
      if (data['code'] != 200) {
        // Error handling
        return;
      }
      setState(() {
        answerNext = data['data']['answerNext'];
        options = List<String>.from(data['data']['options']);
        meta = '题目: ' + data['data']['poetryMeta']['title'] + ' \n朝代：' + data['data']['poetryMeta']['dynasty'] + ' \n作者：' + data['data']['poetryMeta']['author'];
        print(meta);
        if (answerNext) {
          quest = data['data']['line'];
          answer = data['data']['answer'];
        } else {
          quest = data['data']['line'];
          answer = data['data']['answer'];
        }
      });
    } else {
      // Error handling
      throw Exception('Failed to load poem');
    }
  }

  void checkAnswer() {
  if (_controller.text.trim() == answer) {
    // Correct answer
    fetchPoem(); // Fetch a new poem
  } else {
    // Wrong answer, show an error or a hint
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('您的回答错误，请再次尝试'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  _controller.clear(); // Clear text field for the next input
}

void showCorrectAnswerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('回答正确', style: TextStyle(color: Colors.green), textAlign: TextAlign.center,),
        content: Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(meta, textAlign: TextAlign.center,), // 替换为你的meta信息
              // 其他meta信息
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('确定'),
            onPressed: () {
              Navigator.of(context).pop();
              fetchPoem(); // 加载下一题
            },
          )
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('古诗接龙'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/gushi.png', // Replace with your image path
            width: 800,
            height: 200,
          ),
          SizedBox(height: 180,),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 120),
                // const SizedBox(height: 50, child: Text('补全古诗', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                Text(answerNext? '请回答下一句' : '请回答上一句', 
                  style: const TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(quest, 
                  style: const TextStyle(
                      fontSize: 18, 
                      color: Color.fromARGB(255, 84, 195, 225),
                      fontWeight: FontWeight.bold)),
                
                const SizedBox(height: 10),
                ...options.map((option) => Center(
                  child: RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _selectedOption,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedOption = value;
                        if (value == answer) {
                          // 答案正确，加载下一题
                          // 在屏幕中间提示用户回答正确，上面展示这首诗的meta信息，有确定的button, 点击后加载下一题
                          showCorrectAnswerDialog(context);
                          // fetchPoem();
                        } else {
                          // 答案错误，提示用户
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('您的回答错误，请再次尝试'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      });
                    },
                  ),
                )).toList(),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // 在这里添加按钮的点击事件
              //     },
              //     child: const Text('提交'),
              //   ),
              // ),
                
                // 替换或者在ElevatedButton旁边添加一个新的按钮用于语音输入
                // FloatingActionButton(
                //   onPressed: _speech.isNotListening ? _speech.startListening : _speech.stop,
                //   // child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                // ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
