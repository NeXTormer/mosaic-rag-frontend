import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/widgets/chat_message.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';

class ConversationalSearchSection extends StatefulWidget {
  ConversationalSearchSection({super.key});

  @override
  State<ConversationalSearchSection> createState() =>
      _ConversationalSearchSectionState();
}

class _ConversationalSearchSectionState
    extends State<ConversationalSearchSection> {
  final List<String> messages2 = [
    "User: Hey, can you help me write a Dart function?",
    "LLM: Of course! What kind of function are you trying to write?",
    "User: I need one that calculates the factorial of a number.",
    "LLM: Got it! Do you want it to be recursive or iterative?",
    "User: Recursive sounds more elegant. Can you show me?",
    "LLM: Sure! Here’s a simple recursive function for factorial in Dart.",
    "User: Awesome! Thanks a lot.",
    "LLM: You’re welcome! Let me know if you’d like to add any error handling.",
  ];

  final List<String> messages = [
    "Hey, I’ve been trying to write a Dart function, but I’m a bit stuck. Could you give me a hand with it?",
    "Absolutely! I’d be happy to help. What kind of function are you trying to create? Are you working on something specific, or just practicing?",
    "I’m trying to write a function that calculates the factorial of a number. I’ve seen it done in other languages, but I’m not sure how to structure it in Dart.",
    "Ah, I see. Factorials are a great example for practicing recursion or loops. Do you have a preference for using recursion, or would you rather go with an iterative approach?",
    "I think recursion sounds a bit more elegant and concise. Plus, I’d love to see how Dart handles recursion. Could you show me what that might look like?",
    "Of course! A recursive function for calculating the factorial is actually quite simple in Dart. I can write out the code for you and explain each step if you’d like.",
    "That would be amazing! I really appreciate it. I’ve been trying to get the hang of recursion, so seeing it in action would be super helpful.",
    "No problem at all! Let me put that together for you. I’ll make sure to include a base case to prevent infinite recursion and handle edge cases properly.",
  ];

  final TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, right: 24, bottom: 16, left: 56),
      child: FredericCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: messages
                      .asMap()
                      .entries
                      .map<Widget>((entry) => ChatMessage(
                          message: entry.value, isUser: entry.key % 2 == 0))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: chatController,
              style: TextStyle(
                fontSize: 13,
                color: theme.textColor,
              ),
              onSubmitted: (query) {},
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hoverColor: null,
                hintStyle: TextStyle(color: theme.greyTextColor),
                prefixIcon: Icon(
                  Icons.question_answer_outlined,
                  color: theme.mainColorInText,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          color: theme.mainColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                hintText: 'Ask anything about the search results...',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 0.6, color: theme.mainColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 0.6, color: theme.greyColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(width: 0.6, color: theme.greyColor),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 0.6)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 0.6, color: theme.greyColor)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 0.6, color: theme.greyColor)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
