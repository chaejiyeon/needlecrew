// 상의 사이즈
class ShirtModel {
  final String bodyWidth; // 상의-품
  final String neckWidth; // 상의-목둘레
  final String sleeveLength; // 상의-소매길이
  final String sleeveWidth; // 상의-소매통
  final String sleeveLessLength; // 상의-민소매 암홀 길이
  final String shoulderLength; // 상의-어깨 길이

  ShirtModel({
    this.bodyWidth = '0',
    this.neckWidth = '0',
    this.sleeveLength = '0',
    this.sleeveWidth = '0',
    this.sleeveLessLength = '0',
    this.shoulderLength = '0',
  });

  factory ShirtModel.fromJson(Map json) {
    return ShirtModel(
        bodyWidth: json['body_width'],
        neckWidth: json['neck_width'],
        sleeveLength: json['sleeve_length'],
        sleeveWidth: json['sleeve_width'],
        sleeveLessLength: json['sleeve_less_length'],
        shoulderLength: json['shoulder_length']);
  }

  Map<String, dynamic> toMap() {
    return {
      'body_width': bodyWidth,
      'neck_width': neckWidth,
      'sleeve_length': sleeveLength,
      'sleeve_width': sleeveWidth,
      'sleeveless_length': sleeveLessLength,
      'shoulder_length': shoulderLength,
    };
  }
}

// 바지 사이즈
class PantsModel {
  final String pantsLength; // 바지-기장
  final String riseLength; // 바지-밑위 길이
  final String wholeWidth; // 바지-전체 통(밑단)
  final String waist; // 바지-허리
  final String heap; // 바지-힙

  PantsModel({
    required this.pantsLength,
    required this.riseLength,
    required this.wholeWidth,
    required this.waist,
    required this.heap,
  });

  factory PantsModel.fromJson(Map json) {
    return PantsModel(
      pantsLength: json['pants_length'],
      riseLength: json['rise_length'],
      wholeWidth: json['whole_width'],
      waist: json['waist'],
      heap: json['heap'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pants_length': pantsLength,
      'rise_length': riseLength,
      'whole_width': wholeWidth,
      'waist': waist,
      'heap': heap,
    };
  }
}

// 스커트 사이즈
class SkirtModel {
  final String skirtLength; // 스커트-기장
  final String wholeWidth; // 스커트-전체 통(밑단)
  final String heap; // 스커트-힙

  SkirtModel({
    required this.skirtLength,
    required this.wholeWidth,
    required this.heap,
  });

  factory SkirtModel.fromJson(Map json) {
    return SkirtModel(
      skirtLength: json['skirt_length'],
      wholeWidth: json['whole_width'],
      heap: json['heap'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'skirt_length': skirtLength,
      'whole_width': wholeWidth,
      'heap': heap,
    };
  }
}

// 아우터 사이즈
class OuterModel {
  final String width; // 아우터-품
  final String neckWidth; // 아우터-목둘레
  final String sleeveLength; // 아우터-소매길이
  final String sleeveLessLength; // 아우터-민소매암홀길이
  final String shoulderLength; // 아우터-어깨길이

  OuterModel({
    required this.width,
    required this.neckWidth,
    required this.sleeveLength,
    required this.sleeveLessLength,
    required this.shoulderLength,
  });

  factory OuterModel.fromJson(Map json) {
    return OuterModel(
        width: json['width'],
        neckWidth: json['neck_width'],
        sleeveLength: json['sleeve_length'],
        sleeveLessLength: json['sleeve_less_length'],
        shoulderLength: json['shoulder_length']);
  }

  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'neck_width': neckWidth,
      'sleeve_length': sleeveLength,
      'sleeve_less_length': sleeveLessLength,
      'shoulder_length': shoulderLength
    };
  }
}
