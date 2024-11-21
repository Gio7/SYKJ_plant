import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plant/common/ui_color.dart';
import 'package:plant/widgets/nav_bar.dart';
import 'package:plant/widgets/page_bg.dart';

import 'chat_expert_controller.dart';

class ChatExpertContent extends StatefulWidget {
  const ChatExpertContent({super.key});

  @override
  State<ChatExpertContent> createState() => _ChatExpertContentState();
}

class _ChatExpertContentState extends State<ChatExpertContent> {
  final ChatExpertController ctr = Get.put(ChatExpertController());
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController listController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
      // Future.delayed(const Duration(milliseconds: 500)).then((value) {
      //   listController.animateTo(
      //     listController.position.maxScrollExtent,
      //     duration: const Duration(milliseconds: 150),
      //     curve: Curves.ease,
      //   );
      // });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBG(
      child: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: Scaffold(
          backgroundColor: UIColor.transparent,
          appBar: NavBar(
            title: 'aiBotanist'.tr,
          ),
          body: Column(
            children: [
              Expanded(
                child: Obx(
                  () => Align(
                    alignment: Alignment.topCenter,
                    child: ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      controller: listController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemBuilder: (_, i) {
                        final item = ctr.chatList[i];
                        if (item['isSelf'] == 1) {
                          return _buildItemSelf(item['content']);
                        }
                        return _buildItemExpert(item['content']);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 24),
                      itemCount: ctr.chatList.length,
                    ),
                  ),
                ),
              ),
              TextField(
                minLines: 1,
                maxLength: 100,
                maxLines: 3,
                controller: _textEditingController,
                // obscureText: obscureText,
                focusNode: _focusNode,
                style: TextStyle(fontSize: 14, color: UIColor.c15221D, fontWeight: FontWeightExt.medium),
                onSubmitted: (value) async {
                  if (value.trim().isEmpty || ctr.isLoading.value) {
                    return;
                  }
                  await ctr.insertChat(value, true);
                  _textEditingController.clear();
                },
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'writeYourMessage'.tr,
                  hintStyle: TextStyle(fontSize: 14, color: UIColor.cB3B3B3, fontWeight: FontWeightExt.medium),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  counterText: '',
                  fillColor: UIColor.white,
                  filled: true,
                  suffixIcon: UnconstrainedBox(
                    child: IconButton(
                      onPressed: () async {
                        if (_textEditingController.text.trim().isEmpty || ctr.isLoading.value) {
                          return;
                        }
                        await ctr.insertChat(_textEditingController.text, true);
                        // Future.delayed(const Duration(milliseconds: 100)).then((value) {
                        //   listController.animateTo(
                        //     listController.position.minScrollExtent,
                        //     duration: const Duration(milliseconds: 300),
                        //     curve: Curves.ease,
                        //   );
                        // });
                        _textEditingController.clear();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: UIColor.c40BD95,
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemSelf(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [UIColor.c40BD95, UIColor.cAEE9CD],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: UIColor.white,
                fontSize: 12,
                fontWeight: FontWeightExt.medium,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Image.asset('images/icon/chat_user.png', width: 40),
      ],
    );
  }

  Widget _buildItemExpert(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('images/icon/chat_expert2.png', width: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const ShapeDecoration(
              color: UIColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
            child: text.isEmpty
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : SelectableText(
                    text,
                    style: TextStyle(
                      color: UIColor.c8E8B8B,
                      fontSize: 12,
                      fontWeight: FontWeightExt.medium,
                    ),
                    contextMenuBuilder: (c, selectableTextState) {
                      // final List<ContextMenuButtonItem> buttonItems = selectableTextState.contextMenuButtonItems;
                      // buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
                      //   return buttonItem.type == ContextMenuButtonType.cut;
                      // });

                      return AdaptiveTextSelectionToolbar.buttonItems(
                        anchors: selectableTextState.contextMenuAnchors,
                        buttonItems: [
                          ContextMenuButtonItem(
                            onPressed: () {
                              selectableTextState.selectAll(SelectionChangedCause.toolbar);
                            },
                            type: ContextMenuButtonType.selectAll,
                          ),
                          ContextMenuButtonItem(
                            onPressed: () {
                              final String selectedText = selectableTextState.textEditingValue.text.substring(
                                selectableTextState.textEditingValue.selection.start,
                                selectableTextState.textEditingValue.selection.end,
                              );
                              Clipboard.setData(ClipboardData(text: selectedText));
                              selectableTextState.hideToolbar();
                            },
                            type: ContextMenuButtonType.copy,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
