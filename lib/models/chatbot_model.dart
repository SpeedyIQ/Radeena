class ChatbotModel {
  List<Map<String, String>> predefinedQuestions = [
    {"question": "How can I help you? 🤓", "response": "How can I help you?"},
  ];

  List<Map<String, String>> getInitialOptions() {
    return [
      {"question": "I would like to know more about Faraid’s lesson"},
      {"question": "I would like to know more about Faraid’s Dalil"}
    ];
  }

  List<Map<String, String>> getQuestionsForInput(
      List<Map<String, dynamic>> dataList, String key) {
    var uniqueQuestions =
        dataList.map((data) => data[key] as String).toSet().toList();
    return uniqueQuestions.map((question) => {"question": question}).toList();
  }
}
