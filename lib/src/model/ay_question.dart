class AYQuestion {
  String questionType;
  int score;
  String quizType;
  int questionId;
  int questionSt;
  String question;
  List<Options> options;
  List<Answer> answer;
  PikacharAnswer pikacharAnswer;
  int answerIndex;
  String artifactPath;
  int level;
  String date;
  String reference;
  List<String> jumbledata;
  int timeLimit;
  int iV;

  AYQuestion(
      {this.questionType,
      this.score,
      this.quizType,
      this.questionId,
      this.questionSt,
      this.question,
      this.options,
      this.answer,
      this.artifactPath,
      this.level,
      this.date,
      this.reference,
      this.jumbledata,
      this.timeLimit,
      this.iV});

  static List<AYQuestion> fromJsonArray(List<dynamic> json) {
    return json.map((dynamic model) => AYQuestion.fromJson(model)).toList();
  }

  void setAnswerIndex() {
    if (answer.isNotEmpty) {
      int index = 0;
      options.forEach((option) {
        if (option.option == answer.first.answer) {
          answerIndex = index;
        }
        index++;
      });
    }
  }

  AYQuestion.fromJson(Map<String, dynamic> json) {
    questionType = json['question_type'];
    score = json['score'];
    quizType = json['quiz_type'];
    questionId = json['question_id'];
    questionSt = json['question_st'];
    question = json['question'];
    timeLimit = json['time_limit'];
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
    if (json['answer'] != null) {
      answer = new List<Answer>();
      json['answer'].forEach((v) {
        answer.add(new Answer.fromJson(v));
      });
    }

    if (json['pikacharanswer'] != null) {
      List pikacharanswer = new List<List<String>>();
      json['pikacharanswer'].forEach((v) {
        List abc = new List<String>();
        v.forEach((w) {
          abc.add(w);
        });
        pikacharanswer.add(abc);
        this.pikacharAnswer = PikacharAnswer.fromJson(pikacharanswer);
      });
    }

    setAnswerIndex();
    artifactPath = json['artifact_path'];
    level = json['level'];
    date = json['date'];
    reference = json['reference'];
    if (json['jumbledata'] != null) {
      jumbledata = new List<String>();
      json['jumbledata'].forEach((v) {
        jumbledata.add(v);
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_type'] = this.questionType;
    data['score'] = this.score;
    data['quiz_type'] = this.quizType;
    data['question_id'] = this.questionId;
    data['question_st'] = this.questionSt;
    data['question'] = this.question;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    if (this.answer != null) {
      data['answer'] = this.answer.map((v) => v.toJson()).toList();
    }
    data['artifact_path'] = this.artifactPath;
    data['level'] = this.level;
    data['date'] = this.date;
    data['reference'] = this.reference;
    data['__v'] = this.iV;
    return data;
  }

  @override
  String toString() {
    return 'AYQuestion{questionType: $questionType, score: $score, quizType: $quizType, questionId: $questionId, questionSt: $questionSt, question: $question, options: $options, answer: $answer, artifactPath: $artifactPath, level: $level, date: $date, reference: $reference, jumbledata: $jumbledata, iV: $iV}';
  }
}

class Answer {
  String sId;
  String answer;

  Answer({this.sId, this.answer});

  Answer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['answer'] = this.answer;
    return data;
  }

  @override
  String toString() {
    return 'Answer{answer: $answer}';
  }
}

class PikacharAnswer {
  List<List<String>> answer;

  PikacharAnswer({this.answer});

  PikacharAnswer.fromJson(List json) {
    answer = json;
  }

  @override
  String toString() {
    return 'Answer{answer: $answer}';
  }
}

class Options {
  int optionNumber;
  String option;

  Options({this.optionNumber, this.option});

  Options.fromJson(Map<String, dynamic> json) {
    optionNumber = json['option_number'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_number'] = this.optionNumber;
    data['option'] = this.option;
    return data;
  }

  @override
  String toString() {
    return 'Options{optionNumber: $optionNumber, option: $option}';
  }
}
