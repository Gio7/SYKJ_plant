import 'package:flutter/material.dart';

import 'chat_expert_empty.dart';

class ChatExpertPage extends StatelessWidget {
  const ChatExpertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: ChatExpertEmpty(),
    );
  }
}
