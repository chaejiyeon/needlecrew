// 상의 사이즈
class ShirtModel {
  final String length; // 상의-총 길이
  final String width; // 상의-품
  final String neckWidth; // 상의-목둘레
  final String sleeveLength; // 상의-소매길이
  final String sleeveWidth; // 상의-소매통
  final String sleeveLessLength; // 상의-민소매 암홀 길이
  final String shoulderLength; // 상의-어깨 길이

  ShirtModel({
    this.length = '0',
    this.width = '0',
    this.neckWidth = '0',
    this.sleeveLength = '0',
    this.sleeveWidth = '0',
    this.sleeveLessLength = '0',
    this.shoulderLength = '0',
  });

  factory ShirtModel.fromJson(Map json) {
    return ShirtModel(
        length: json['length'],
        width: json['width'],
        neckWidth: json['neck_width'],
        sleeveLength: json['sleeve_length'],
        sleeveWidth: json['sleeve_width'],
        sleeveLessLength: json['sleeve_less_length'],
        shoulderLength: json['shoulder_length']);
  }

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'width': width,
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
  final String length; // 바지-총 길이
  final String riseLength; // 바지-밑위 길이
  final String waist; // 바지-허리
  final String wholeWidth; // 바지-전체 통(밑단)
  final String heap; // 바지-힙

  PantsModel({
    this.length = '0',
    this.riseLength = '0',
    this.waist = '0',
    this.wholeWidth = '0',
    this.heap = '0',
  });

  factory PantsModel.fromJson(Map json) {
    return PantsModel(
      length: json['length'],
      riseLength: json['rise_length'],
      waist: json['waist'],
      wholeWidth: json['whole_width'],
      heap: json['heap'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'rise_length': riseLength,
      'waist': waist,
      'whole_width': wholeWidth,
      'heap': heap,
    };
  }
}

// 스커트 사이즈
class SkirtModel {
  final String length; // 스커트-총 길이
  final String waist; // 스커트-허리
  final String wholeWidth; // 스커트-전체 통(밑단)
  final String heap; // 스커트-힙

  SkirtModel({
    this.length = '0',
    this.waist = '0',
    this.wholeWidth = '0',
    this.heap = '0',
  });

  factory SkirtModel.fromJson(Map json) {
    return SkirtModel(
      length: json['length'],
      waist: json['waist'],
      wholeWidth: json['whole_width'],
      heap: json['heap'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'waist': waist,
      'whole_width': wholeWidth,
      'heap': heap,
    };
  }
}

// 아우터 사이즈
class OuterModel {
  final String length; // 아우터-총길이
  final String width; // 아우터-품
  final String sleeveLength; // 아우터-소매길이
  final String sleeveWidth; // 아우터-소매 통
  final String shoulderLength; // 아우터-어깨길이
  final String sleeveLessLength; // 아우터-민소매암홀길이

  OuterModel({
    this.length = '0',
    this.width = '0',
    this.sleeveLength = '0',
    this.sleeveWidth = '0',
    this.sleeveLessLength = '0',
    this.shoulderLength = '0',
  });

  factory OuterModel.fromJson(Map json) {
    return OuterModel(
        length: json['length'],
        width: json['width'],
        sleeveLength: json['sleeve_length'],
        sleeveWidth: json['sleeve_width'],
        sleeveLessLength: json['sleeve_less_length'],
        shoulderLength: json['shoulder_length']);
  }

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'width': width,
      'sleeve_length': sleeveLength,
      'sleeve_width': sleeveWidth,
      'sleeve_less_length': sleeveLessLength,
      'shoulder_length': shoulderLength
    };
  }
}

// 원피스 사이즈
class OnepieceModel {
  final String length; // 원피스-총길이
  final String width; // 원피스-품
  final String sleeveLength; // 원피스-소매길이
  final String sleeveWidth; // 원피스-소매 통
  final String sleeveLessLength; // 원피스-민소매암홀길이
  final String shoulderLength; // 원피스-어깨길이

  OnepieceModel({
    this.length = '0',
    this.width = '0',
    this.sleeveLength = '0',
    this.sleeveWidth = '0',
    this.shoulderLength = '0',
    this.sleeveLessLength = '0',
  });

  factory OnepieceModel.fromJson(Map json) {
    return OnepieceModel(
      length: json['length'],
      width: json['width'],
      sleeveLength: json['sleeve_length'],
      sleeveWidth: json['sleeve_width'],
      shoulderLength: json['shoulder_length'],
      sleeveLessLength: json['sleeve_less_length'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'width': width,
      'sleeve_length': sleeveLength,
      'sleeve_width': sleeveWidth,
      'shoulder_length': shoulderLength,
      'sleeve_less_length': sleeveLessLength,
    };
  }
}
