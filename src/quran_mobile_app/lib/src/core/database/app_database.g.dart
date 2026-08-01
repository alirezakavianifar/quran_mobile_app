// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SurahsTable extends Surahs with TableInfo<$SurahsTable, Surah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArabicMeta = const VerificationMeta(
    'nameArabic',
  );
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
    'name_arabic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namePersianMeta = const VerificationMeta(
    'namePersian',
  );
  @override
  late final GeneratedColumn<String> namePersian = GeneratedColumn<String>(
    'name_persian',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnglishMeta = const VerificationMeta(
    'nameEnglish',
  );
  @override
  late final GeneratedColumn<String> nameEnglish = GeneratedColumn<String>(
    'name_english',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revelationTypeMeta = const VerificationMeta(
    'revelationType',
  );
  @override
  late final GeneratedColumn<String> revelationType = GeneratedColumn<String>(
    'revelation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseCountMeta = const VerificationMeta(
    'verseCount',
  );
  @override
  late final GeneratedColumn<int> verseCount = GeneratedColumn<int>(
    'verse_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    number,
    nameArabic,
    namePersian,
    nameEnglish,
    revelationType,
    verseCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Surah> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
        _nameArabicMeta,
        nameArabic.isAcceptableOrUnknown(data['name_arabic']!, _nameArabicMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('name_persian')) {
      context.handle(
        _namePersianMeta,
        namePersian.isAcceptableOrUnknown(
          data['name_persian']!,
          _namePersianMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_namePersianMeta);
    }
    if (data.containsKey('name_english')) {
      context.handle(
        _nameEnglishMeta,
        nameEnglish.isAcceptableOrUnknown(
          data['name_english']!,
          _nameEnglishMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameEnglishMeta);
    }
    if (data.containsKey('revelation_type')) {
      context.handle(
        _revelationTypeMeta,
        revelationType.isAcceptableOrUnknown(
          data['revelation_type']!,
          _revelationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_revelationTypeMeta);
    }
    if (data.containsKey('verse_count')) {
      context.handle(
        _verseCountMeta,
        verseCount.isAcceptableOrUnknown(data['verse_count']!, _verseCountMeta),
      );
    } else if (isInserting) {
      context.missing(_verseCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Surah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surah(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number'],
      )!,
      nameArabic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_arabic'],
      )!,
      namePersian: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_persian'],
      )!,
      nameEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_english'],
      )!,
      revelationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}revelation_type'],
      )!,
      verseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_count'],
      )!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class Surah extends DataClass implements Insertable<Surah> {
  final int id;
  final int number;
  final String nameArabic;
  final String namePersian;
  final String nameEnglish;
  final String revelationType;
  final int verseCount;
  const Surah({
    required this.id,
    required this.number,
    required this.nameArabic,
    required this.namePersian,
    required this.nameEnglish,
    required this.revelationType,
    required this.verseCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['number'] = Variable<int>(number);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['name_persian'] = Variable<String>(namePersian);
    map['name_english'] = Variable<String>(nameEnglish);
    map['revelation_type'] = Variable<String>(revelationType);
    map['verse_count'] = Variable<int>(verseCount);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      id: Value(id),
      number: Value(number),
      nameArabic: Value(nameArabic),
      namePersian: Value(namePersian),
      nameEnglish: Value(nameEnglish),
      revelationType: Value(revelationType),
      verseCount: Value(verseCount),
    );
  }

  factory Surah.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surah(
      id: serializer.fromJson<int>(json['id']),
      number: serializer.fromJson<int>(json['number']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      namePersian: serializer.fromJson<String>(json['namePersian']),
      nameEnglish: serializer.fromJson<String>(json['nameEnglish']),
      revelationType: serializer.fromJson<String>(json['revelationType']),
      verseCount: serializer.fromJson<int>(json['verseCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'number': serializer.toJson<int>(number),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'namePersian': serializer.toJson<String>(namePersian),
      'nameEnglish': serializer.toJson<String>(nameEnglish),
      'revelationType': serializer.toJson<String>(revelationType),
      'verseCount': serializer.toJson<int>(verseCount),
    };
  }

  Surah copyWith({
    int? id,
    int? number,
    String? nameArabic,
    String? namePersian,
    String? nameEnglish,
    String? revelationType,
    int? verseCount,
  }) => Surah(
    id: id ?? this.id,
    number: number ?? this.number,
    nameArabic: nameArabic ?? this.nameArabic,
    namePersian: namePersian ?? this.namePersian,
    nameEnglish: nameEnglish ?? this.nameEnglish,
    revelationType: revelationType ?? this.revelationType,
    verseCount: verseCount ?? this.verseCount,
  );
  Surah copyWithCompanion(SurahsCompanion data) {
    return Surah(
      id: data.id.present ? data.id.value : this.id,
      number: data.number.present ? data.number.value : this.number,
      nameArabic: data.nameArabic.present
          ? data.nameArabic.value
          : this.nameArabic,
      namePersian: data.namePersian.present
          ? data.namePersian.value
          : this.namePersian,
      nameEnglish: data.nameEnglish.present
          ? data.nameEnglish.value
          : this.nameEnglish,
      revelationType: data.revelationType.present
          ? data.revelationType.value
          : this.revelationType,
      verseCount: data.verseCount.present
          ? data.verseCount.value
          : this.verseCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Surah(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('namePersian: $namePersian, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('revelationType: $revelationType, ')
          ..write('verseCount: $verseCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    number,
    nameArabic,
    namePersian,
    nameEnglish,
    revelationType,
    verseCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.id == this.id &&
          other.number == this.number &&
          other.nameArabic == this.nameArabic &&
          other.namePersian == this.namePersian &&
          other.nameEnglish == this.nameEnglish &&
          other.revelationType == this.revelationType &&
          other.verseCount == this.verseCount);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<int> id;
  final Value<int> number;
  final Value<String> nameArabic;
  final Value<String> namePersian;
  final Value<String> nameEnglish;
  final Value<String> revelationType;
  final Value<int> verseCount;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.number = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.namePersian = const Value.absent(),
    this.nameEnglish = const Value.absent(),
    this.revelationType = const Value.absent(),
    this.verseCount = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.id = const Value.absent(),
    required int number,
    required String nameArabic,
    required String namePersian,
    required String nameEnglish,
    required String revelationType,
    required int verseCount,
  }) : number = Value(number),
       nameArabic = Value(nameArabic),
       namePersian = Value(namePersian),
       nameEnglish = Value(nameEnglish),
       revelationType = Value(revelationType),
       verseCount = Value(verseCount);
  static Insertable<Surah> custom({
    Expression<int>? id,
    Expression<int>? number,
    Expression<String>? nameArabic,
    Expression<String>? namePersian,
    Expression<String>? nameEnglish,
    Expression<String>? revelationType,
    Expression<int>? verseCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (number != null) 'number': number,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (namePersian != null) 'name_persian': namePersian,
      if (nameEnglish != null) 'name_english': nameEnglish,
      if (revelationType != null) 'revelation_type': revelationType,
      if (verseCount != null) 'verse_count': verseCount,
    });
  }

  SurahsCompanion copyWith({
    Value<int>? id,
    Value<int>? number,
    Value<String>? nameArabic,
    Value<String>? namePersian,
    Value<String>? nameEnglish,
    Value<String>? revelationType,
    Value<int>? verseCount,
  }) {
    return SurahsCompanion(
      id: id ?? this.id,
      number: number ?? this.number,
      nameArabic: nameArabic ?? this.nameArabic,
      namePersian: namePersian ?? this.namePersian,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      revelationType: revelationType ?? this.revelationType,
      verseCount: verseCount ?? this.verseCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (namePersian.present) {
      map['name_persian'] = Variable<String>(namePersian.value);
    }
    if (nameEnglish.present) {
      map['name_english'] = Variable<String>(nameEnglish.value);
    }
    if (revelationType.present) {
      map['revelation_type'] = Variable<String>(revelationType.value);
    }
    if (verseCount.present) {
      map['verse_count'] = Variable<int>(verseCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('number: $number, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('namePersian: $namePersian, ')
          ..write('nameEnglish: $nameEnglish, ')
          ..write('revelationType: $revelationType, ')
          ..write('verseCount: $verseCount')
          ..write(')'))
        .toString();
  }
}

class $VersesTable extends Verses with TableInfo<$VersesTable, Verse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahIdMeta = const VerificationMeta(
    'surahId',
  );
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
    'surah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseNumberMeta = const VerificationMeta(
    'verseNumber',
  );
  @override
  late final GeneratedColumn<int> verseNumber = GeneratedColumn<int>(
    'verse_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textUthmaniMeta = const VerificationMeta(
    'textUthmani',
  );
  @override
  late final GeneratedColumn<String> textUthmani = GeneratedColumn<String>(
    'text_uthmani',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textSimpleMeta = const VerificationMeta(
    'textSimple',
  );
  @override
  late final GeneratedColumn<String> textSimple = GeneratedColumn<String>(
    'text_simple',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _juzNumberMeta = const VerificationMeta(
    'juzNumber',
  );
  @override
  late final GeneratedColumn<int> juzNumber = GeneratedColumn<int>(
    'juz_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahId,
    verseNumber,
    textUthmani,
    textSimple,
    pageNumber,
    juzNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Verse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_id')) {
      context.handle(
        _surahIdMeta,
        surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('verse_number')) {
      context.handle(
        _verseNumberMeta,
        verseNumber.isAcceptableOrUnknown(
          data['verse_number']!,
          _verseNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verseNumberMeta);
    }
    if (data.containsKey('text_uthmani')) {
      context.handle(
        _textUthmaniMeta,
        textUthmani.isAcceptableOrUnknown(
          data['text_uthmani']!,
          _textUthmaniMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_textUthmaniMeta);
    }
    if (data.containsKey('text_simple')) {
      context.handle(
        _textSimpleMeta,
        textSimple.isAcceptableOrUnknown(data['text_simple']!, _textSimpleMeta),
      );
    } else if (isInserting) {
      context.missing(_textSimpleMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('juz_number')) {
      context.handle(
        _juzNumberMeta,
        juzNumber.isAcceptableOrUnknown(data['juz_number']!, _juzNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_juzNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Verse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_id'],
      )!,
      verseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_number'],
      )!,
      textUthmani: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_uthmani'],
      )!,
      textSimple: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_simple'],
      )!,
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      )!,
      juzNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}juz_number'],
      )!,
    );
  }

  @override
  $VersesTable createAlias(String alias) {
    return $VersesTable(attachedDatabase, alias);
  }
}

class Verse extends DataClass implements Insertable<Verse> {
  final int id;
  final int surahId;
  final int verseNumber;
  final String textUthmani;
  final String textSimple;
  final int pageNumber;
  final int juzNumber;
  const Verse({
    required this.id,
    required this.surahId,
    required this.verseNumber,
    required this.textUthmani,
    required this.textSimple,
    required this.pageNumber,
    required this.juzNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_id'] = Variable<int>(surahId);
    map['verse_number'] = Variable<int>(verseNumber);
    map['text_uthmani'] = Variable<String>(textUthmani);
    map['text_simple'] = Variable<String>(textSimple);
    map['page_number'] = Variable<int>(pageNumber);
    map['juz_number'] = Variable<int>(juzNumber);
    return map;
  }

  VersesCompanion toCompanion(bool nullToAbsent) {
    return VersesCompanion(
      id: Value(id),
      surahId: Value(surahId),
      verseNumber: Value(verseNumber),
      textUthmani: Value(textUthmani),
      textSimple: Value(textSimple),
      pageNumber: Value(pageNumber),
      juzNumber: Value(juzNumber),
    );
  }

  factory Verse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verse(
      id: serializer.fromJson<int>(json['id']),
      surahId: serializer.fromJson<int>(json['surahId']),
      verseNumber: serializer.fromJson<int>(json['verseNumber']),
      textUthmani: serializer.fromJson<String>(json['textUthmani']),
      textSimple: serializer.fromJson<String>(json['textSimple']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      juzNumber: serializer.fromJson<int>(json['juzNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahId': serializer.toJson<int>(surahId),
      'verseNumber': serializer.toJson<int>(verseNumber),
      'textUthmani': serializer.toJson<String>(textUthmani),
      'textSimple': serializer.toJson<String>(textSimple),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'juzNumber': serializer.toJson<int>(juzNumber),
    };
  }

  Verse copyWith({
    int? id,
    int? surahId,
    int? verseNumber,
    String? textUthmani,
    String? textSimple,
    int? pageNumber,
    int? juzNumber,
  }) => Verse(
    id: id ?? this.id,
    surahId: surahId ?? this.surahId,
    verseNumber: verseNumber ?? this.verseNumber,
    textUthmani: textUthmani ?? this.textUthmani,
    textSimple: textSimple ?? this.textSimple,
    pageNumber: pageNumber ?? this.pageNumber,
    juzNumber: juzNumber ?? this.juzNumber,
  );
  Verse copyWithCompanion(VersesCompanion data) {
    return Verse(
      id: data.id.present ? data.id.value : this.id,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      verseNumber: data.verseNumber.present
          ? data.verseNumber.value
          : this.verseNumber,
      textUthmani: data.textUthmani.present
          ? data.textUthmani.value
          : this.textUthmani,
      textSimple: data.textSimple.present
          ? data.textSimple.value
          : this.textSimple,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      juzNumber: data.juzNumber.present ? data.juzNumber.value : this.juzNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verse(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textSimple: $textSimple, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('juzNumber: $juzNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    surahId,
    verseNumber,
    textUthmani,
    textSimple,
    pageNumber,
    juzNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verse &&
          other.id == this.id &&
          other.surahId == this.surahId &&
          other.verseNumber == this.verseNumber &&
          other.textUthmani == this.textUthmani &&
          other.textSimple == this.textSimple &&
          other.pageNumber == this.pageNumber &&
          other.juzNumber == this.juzNumber);
}

class VersesCompanion extends UpdateCompanion<Verse> {
  final Value<int> id;
  final Value<int> surahId;
  final Value<int> verseNumber;
  final Value<String> textUthmani;
  final Value<String> textSimple;
  final Value<int> pageNumber;
  final Value<int> juzNumber;
  const VersesCompanion({
    this.id = const Value.absent(),
    this.surahId = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.textUthmani = const Value.absent(),
    this.textSimple = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.juzNumber = const Value.absent(),
  });
  VersesCompanion.insert({
    this.id = const Value.absent(),
    required int surahId,
    required int verseNumber,
    required String textUthmani,
    required String textSimple,
    required int pageNumber,
    required int juzNumber,
  }) : surahId = Value(surahId),
       verseNumber = Value(verseNumber),
       textUthmani = Value(textUthmani),
       textSimple = Value(textSimple),
       pageNumber = Value(pageNumber),
       juzNumber = Value(juzNumber);
  static Insertable<Verse> custom({
    Expression<int>? id,
    Expression<int>? surahId,
    Expression<int>? verseNumber,
    Expression<String>? textUthmani,
    Expression<String>? textSimple,
    Expression<int>? pageNumber,
    Expression<int>? juzNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahId != null) 'surah_id': surahId,
      if (verseNumber != null) 'verse_number': verseNumber,
      if (textUthmani != null) 'text_uthmani': textUthmani,
      if (textSimple != null) 'text_simple': textSimple,
      if (pageNumber != null) 'page_number': pageNumber,
      if (juzNumber != null) 'juz_number': juzNumber,
    });
  }

  VersesCompanion copyWith({
    Value<int>? id,
    Value<int>? surahId,
    Value<int>? verseNumber,
    Value<String>? textUthmani,
    Value<String>? textSimple,
    Value<int>? pageNumber,
    Value<int>? juzNumber,
  }) {
    return VersesCompanion(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      verseNumber: verseNumber ?? this.verseNumber,
      textUthmani: textUthmani ?? this.textUthmani,
      textSimple: textSimple ?? this.textSimple,
      pageNumber: pageNumber ?? this.pageNumber,
      juzNumber: juzNumber ?? this.juzNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (verseNumber.present) {
      map['verse_number'] = Variable<int>(verseNumber.value);
    }
    if (textUthmani.present) {
      map['text_uthmani'] = Variable<String>(textUthmani.value);
    }
    if (textSimple.present) {
      map['text_simple'] = Variable<String>(textSimple.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (juzNumber.present) {
      map['juz_number'] = Variable<int>(juzNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesCompanion(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('textSimple: $textSimple, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('juzNumber: $juzNumber')
          ..write(')'))
        .toString();
  }
}

class $TranslationsTable extends Translations
    with TableInfo<$TranslationsTable, Translation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _verseIdMeta = const VerificationMeta(
    'verseId',
  );
  @override
  late final GeneratedColumn<int> verseId = GeneratedColumn<int>(
    'verse_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationTextMeta = const VerificationMeta(
    'translationText',
  );
  @override
  late final GeneratedColumn<String> translationText = GeneratedColumn<String>(
    'translation_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    verseId,
    languageCode,
    authorName,
    translationText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Translation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('verse_id')) {
      context.handle(
        _verseIdMeta,
        verseId.isAcceptableOrUnknown(data['verse_id']!, _verseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_verseIdMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_authorNameMeta);
    }
    if (data.containsKey('translation_text')) {
      context.handle(
        _translationTextMeta,
        translationText.isAcceptableOrUnknown(
          data['translation_text']!,
          _translationTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Translation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Translation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      verseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      )!,
      translationText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_text'],
      )!,
    );
  }

  @override
  $TranslationsTable createAlias(String alias) {
    return $TranslationsTable(attachedDatabase, alias);
  }
}

class Translation extends DataClass implements Insertable<Translation> {
  final int id;
  final int verseId;
  final String languageCode;
  final String authorName;
  final String translationText;
  const Translation({
    required this.id,
    required this.verseId,
    required this.languageCode,
    required this.authorName,
    required this.translationText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['verse_id'] = Variable<int>(verseId);
    map['language_code'] = Variable<String>(languageCode);
    map['author_name'] = Variable<String>(authorName);
    map['translation_text'] = Variable<String>(translationText);
    return map;
  }

  TranslationsCompanion toCompanion(bool nullToAbsent) {
    return TranslationsCompanion(
      id: Value(id),
      verseId: Value(verseId),
      languageCode: Value(languageCode),
      authorName: Value(authorName),
      translationText: Value(translationText),
    );
  }

  factory Translation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Translation(
      id: serializer.fromJson<int>(json['id']),
      verseId: serializer.fromJson<int>(json['verseId']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      authorName: serializer.fromJson<String>(json['authorName']),
      translationText: serializer.fromJson<String>(json['translationText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'verseId': serializer.toJson<int>(verseId),
      'languageCode': serializer.toJson<String>(languageCode),
      'authorName': serializer.toJson<String>(authorName),
      'translationText': serializer.toJson<String>(translationText),
    };
  }

  Translation copyWith({
    int? id,
    int? verseId,
    String? languageCode,
    String? authorName,
    String? translationText,
  }) => Translation(
    id: id ?? this.id,
    verseId: verseId ?? this.verseId,
    languageCode: languageCode ?? this.languageCode,
    authorName: authorName ?? this.authorName,
    translationText: translationText ?? this.translationText,
  );
  Translation copyWithCompanion(TranslationsCompanion data) {
    return Translation(
      id: data.id.present ? data.id.value : this.id,
      verseId: data.verseId.present ? data.verseId.value : this.verseId,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      translationText: data.translationText.present
          ? data.translationText.value
          : this.translationText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Translation(')
          ..write('id: $id, ')
          ..write('verseId: $verseId, ')
          ..write('languageCode: $languageCode, ')
          ..write('authorName: $authorName, ')
          ..write('translationText: $translationText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, verseId, languageCode, authorName, translationText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Translation &&
          other.id == this.id &&
          other.verseId == this.verseId &&
          other.languageCode == this.languageCode &&
          other.authorName == this.authorName &&
          other.translationText == this.translationText);
}

class TranslationsCompanion extends UpdateCompanion<Translation> {
  final Value<int> id;
  final Value<int> verseId;
  final Value<String> languageCode;
  final Value<String> authorName;
  final Value<String> translationText;
  const TranslationsCompanion({
    this.id = const Value.absent(),
    this.verseId = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.authorName = const Value.absent(),
    this.translationText = const Value.absent(),
  });
  TranslationsCompanion.insert({
    this.id = const Value.absent(),
    required int verseId,
    required String languageCode,
    required String authorName,
    required String translationText,
  }) : verseId = Value(verseId),
       languageCode = Value(languageCode),
       authorName = Value(authorName),
       translationText = Value(translationText);
  static Insertable<Translation> custom({
    Expression<int>? id,
    Expression<int>? verseId,
    Expression<String>? languageCode,
    Expression<String>? authorName,
    Expression<String>? translationText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (verseId != null) 'verse_id': verseId,
      if (languageCode != null) 'language_code': languageCode,
      if (authorName != null) 'author_name': authorName,
      if (translationText != null) 'translation_text': translationText,
    });
  }

  TranslationsCompanion copyWith({
    Value<int>? id,
    Value<int>? verseId,
    Value<String>? languageCode,
    Value<String>? authorName,
    Value<String>? translationText,
  }) {
    return TranslationsCompanion(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      languageCode: languageCode ?? this.languageCode,
      authorName: authorName ?? this.authorName,
      translationText: translationText ?? this.translationText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (verseId.present) {
      map['verse_id'] = Variable<int>(verseId.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (translationText.present) {
      map['translation_text'] = Variable<String>(translationText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationsCompanion(')
          ..write('id: $id, ')
          ..write('verseId: $verseId, ')
          ..write('languageCode: $languageCode, ')
          ..write('authorName: $authorName, ')
          ..write('translationText: $translationText')
          ..write(')'))
        .toString();
  }
}

class $TafsirsTable extends Tafsirs with TableInfo<$TafsirsTable, Tafsir> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TafsirsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _verseIdMeta = const VerificationMeta(
    'verseId',
  );
  @override
  late final GeneratedColumn<int> verseId = GeneratedColumn<int>(
    'verse_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editionNameMeta = const VerificationMeta(
    'editionName',
  );
  @override
  late final GeneratedColumn<String> editionName = GeneratedColumn<String>(
    'edition_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTextMeta = const VerificationMeta(
    'contentText',
  );
  @override
  late final GeneratedColumn<String> contentText = GeneratedColumn<String>(
    'content_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    verseId,
    editionName,
    languageCode,
    contentText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tafsirs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tafsir> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('verse_id')) {
      context.handle(
        _verseIdMeta,
        verseId.isAcceptableOrUnknown(data['verse_id']!, _verseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_verseIdMeta);
    }
    if (data.containsKey('edition_name')) {
      context.handle(
        _editionNameMeta,
        editionName.isAcceptableOrUnknown(
          data['edition_name']!,
          _editionNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_editionNameMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('content_text')) {
      context.handle(
        _contentTextMeta,
        contentText.isAcceptableOrUnknown(
          data['content_text']!,
          _contentTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tafsir map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tafsir(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      verseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_id'],
      )!,
      editionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edition_name'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      contentText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_text'],
      )!,
    );
  }

  @override
  $TafsirsTable createAlias(String alias) {
    return $TafsirsTable(attachedDatabase, alias);
  }
}

class Tafsir extends DataClass implements Insertable<Tafsir> {
  final int id;
  final int verseId;
  final String editionName;
  final String languageCode;
  final String contentText;
  const Tafsir({
    required this.id,
    required this.verseId,
    required this.editionName,
    required this.languageCode,
    required this.contentText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['verse_id'] = Variable<int>(verseId);
    map['edition_name'] = Variable<String>(editionName);
    map['language_code'] = Variable<String>(languageCode);
    map['content_text'] = Variable<String>(contentText);
    return map;
  }

  TafsirsCompanion toCompanion(bool nullToAbsent) {
    return TafsirsCompanion(
      id: Value(id),
      verseId: Value(verseId),
      editionName: Value(editionName),
      languageCode: Value(languageCode),
      contentText: Value(contentText),
    );
  }

  factory Tafsir.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tafsir(
      id: serializer.fromJson<int>(json['id']),
      verseId: serializer.fromJson<int>(json['verseId']),
      editionName: serializer.fromJson<String>(json['editionName']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      contentText: serializer.fromJson<String>(json['contentText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'verseId': serializer.toJson<int>(verseId),
      'editionName': serializer.toJson<String>(editionName),
      'languageCode': serializer.toJson<String>(languageCode),
      'contentText': serializer.toJson<String>(contentText),
    };
  }

  Tafsir copyWith({
    int? id,
    int? verseId,
    String? editionName,
    String? languageCode,
    String? contentText,
  }) => Tafsir(
    id: id ?? this.id,
    verseId: verseId ?? this.verseId,
    editionName: editionName ?? this.editionName,
    languageCode: languageCode ?? this.languageCode,
    contentText: contentText ?? this.contentText,
  );
  Tafsir copyWithCompanion(TafsirsCompanion data) {
    return Tafsir(
      id: data.id.present ? data.id.value : this.id,
      verseId: data.verseId.present ? data.verseId.value : this.verseId,
      editionName: data.editionName.present
          ? data.editionName.value
          : this.editionName,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      contentText: data.contentText.present
          ? data.contentText.value
          : this.contentText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tafsir(')
          ..write('id: $id, ')
          ..write('verseId: $verseId, ')
          ..write('editionName: $editionName, ')
          ..write('languageCode: $languageCode, ')
          ..write('contentText: $contentText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, verseId, editionName, languageCode, contentText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tafsir &&
          other.id == this.id &&
          other.verseId == this.verseId &&
          other.editionName == this.editionName &&
          other.languageCode == this.languageCode &&
          other.contentText == this.contentText);
}

class TafsirsCompanion extends UpdateCompanion<Tafsir> {
  final Value<int> id;
  final Value<int> verseId;
  final Value<String> editionName;
  final Value<String> languageCode;
  final Value<String> contentText;
  const TafsirsCompanion({
    this.id = const Value.absent(),
    this.verseId = const Value.absent(),
    this.editionName = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.contentText = const Value.absent(),
  });
  TafsirsCompanion.insert({
    this.id = const Value.absent(),
    required int verseId,
    required String editionName,
    required String languageCode,
    required String contentText,
  }) : verseId = Value(verseId),
       editionName = Value(editionName),
       languageCode = Value(languageCode),
       contentText = Value(contentText);
  static Insertable<Tafsir> custom({
    Expression<int>? id,
    Expression<int>? verseId,
    Expression<String>? editionName,
    Expression<String>? languageCode,
    Expression<String>? contentText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (verseId != null) 'verse_id': verseId,
      if (editionName != null) 'edition_name': editionName,
      if (languageCode != null) 'language_code': languageCode,
      if (contentText != null) 'content_text': contentText,
    });
  }

  TafsirsCompanion copyWith({
    Value<int>? id,
    Value<int>? verseId,
    Value<String>? editionName,
    Value<String>? languageCode,
    Value<String>? contentText,
  }) {
    return TafsirsCompanion(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      editionName: editionName ?? this.editionName,
      languageCode: languageCode ?? this.languageCode,
      contentText: contentText ?? this.contentText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (verseId.present) {
      map['verse_id'] = Variable<int>(verseId.value);
    }
    if (editionName.present) {
      map['edition_name'] = Variable<String>(editionName.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (contentText.present) {
      map['content_text'] = Variable<String>(contentText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TafsirsCompanion(')
          ..write('id: $id, ')
          ..write('verseId: $verseId, ')
          ..write('editionName: $editionName, ')
          ..write('languageCode: $languageCode, ')
          ..write('contentText: $contentText')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahIdMeta = const VerificationMeta(
    'surahId',
  );
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
    'surah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseNumberMeta = const VerificationMeta(
    'verseNumber',
  );
  @override
  late final GeneratedColumn<int> verseNumber = GeneratedColumn<int>(
    'verse_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahId,
    verseNumber,
    createdAt,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Bookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_id')) {
      context.handle(
        _surahIdMeta,
        surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('verse_number')) {
      context.handle(
        _verseNumberMeta,
        verseNumber.isAcceptableOrUnknown(
          data['verse_number']!,
          _verseNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verseNumberMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_id'],
      )!,
      verseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_number'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final int id;
  final int surahId;
  final int verseNumber;
  final DateTime createdAt;
  final String? note;
  const Bookmark({
    required this.id,
    required this.surahId,
    required this.verseNumber,
    required this.createdAt,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_id'] = Variable<int>(surahId);
    map['verse_number'] = Variable<int>(verseNumber);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      surahId: Value(surahId),
      verseNumber: Value(verseNumber),
      createdAt: Value(createdAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Bookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      id: serializer.fromJson<int>(json['id']),
      surahId: serializer.fromJson<int>(json['surahId']),
      verseNumber: serializer.fromJson<int>(json['verseNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahId': serializer.toJson<int>(surahId),
      'verseNumber': serializer.toJson<int>(verseNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'note': serializer.toJson<String?>(note),
    };
  }

  Bookmark copyWith({
    int? id,
    int? surahId,
    int? verseNumber,
    DateTime? createdAt,
    Value<String?> note = const Value.absent(),
  }) => Bookmark(
    id: id ?? this.id,
    surahId: surahId ?? this.surahId,
    verseNumber: verseNumber ?? this.verseNumber,
    createdAt: createdAt ?? this.createdAt,
    note: note.present ? note.value : this.note,
  );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      id: data.id.present ? data.id.value : this.id,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      verseNumber: data.verseNumber.present
          ? data.verseNumber.value
          : this.verseNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahId, verseNumber, createdAt, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.surahId == this.surahId &&
          other.verseNumber == this.verseNumber &&
          other.createdAt == this.createdAt &&
          other.note == this.note);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<int> id;
  final Value<int> surahId;
  final Value<int> verseNumber;
  final Value<DateTime> createdAt;
  final Value<String?> note;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.surahId = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.note = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    required int surahId,
    required int verseNumber,
    this.createdAt = const Value.absent(),
    this.note = const Value.absent(),
  }) : surahId = Value(surahId),
       verseNumber = Value(verseNumber);
  static Insertable<Bookmark> custom({
    Expression<int>? id,
    Expression<int>? surahId,
    Expression<int>? verseNumber,
    Expression<DateTime>? createdAt,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahId != null) 'surah_id': surahId,
      if (verseNumber != null) 'verse_number': verseNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (note != null) 'note': note,
    });
  }

  BookmarksCompanion copyWith({
    Value<int>? id,
    Value<int>? surahId,
    Value<int>? verseNumber,
    Value<DateTime>? createdAt,
    Value<String?>? note,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      verseNumber: verseNumber ?? this.verseNumber,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (verseNumber.present) {
      map['verse_number'] = Variable<int>(verseNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $VersesTable verses = $VersesTable(this);
  late final $TranslationsTable translations = $TranslationsTable(this);
  late final $TafsirsTable tafsirs = $TafsirsTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    surahs,
    verses,
    translations,
    tafsirs,
    bookmarks,
  ];
}

typedef $$SurahsTableCreateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      required int number,
      required String nameArabic,
      required String namePersian,
      required String nameEnglish,
      required String revelationType,
      required int verseCount,
    });
typedef $$SurahsTableUpdateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      Value<int> number,
      Value<String> nameArabic,
      Value<String> namePersian,
      Value<String> nameEnglish,
      Value<String> revelationType,
      Value<int> verseCount,
    });

class $$SurahsTableFilterComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namePersian => $composableBuilder(
    column: $table.namePersian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get revelationType => $composableBuilder(
    column: $table.revelationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SurahsTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namePersian => $composableBuilder(
    column: $table.namePersian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get revelationType => $composableBuilder(
    column: $table.revelationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get nameArabic => $composableBuilder(
    column: $table.nameArabic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get namePersian => $composableBuilder(
    column: $table.namePersian,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nameEnglish => $composableBuilder(
    column: $table.nameEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get revelationType => $composableBuilder(
    column: $table.revelationType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => column,
  );
}

class $$SurahsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurahsTable,
          Surah,
          $$SurahsTableFilterComposer,
          $$SurahsTableOrderingComposer,
          $$SurahsTableAnnotationComposer,
          $$SurahsTableCreateCompanionBuilder,
          $$SurahsTableUpdateCompanionBuilder,
          (Surah, BaseReferences<_$AppDatabase, $SurahsTable, Surah>),
          Surah,
          PrefetchHooks Function()
        > {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> number = const Value.absent(),
                Value<String> nameArabic = const Value.absent(),
                Value<String> namePersian = const Value.absent(),
                Value<String> nameEnglish = const Value.absent(),
                Value<String> revelationType = const Value.absent(),
                Value<int> verseCount = const Value.absent(),
              }) => SurahsCompanion(
                id: id,
                number: number,
                nameArabic: nameArabic,
                namePersian: namePersian,
                nameEnglish: nameEnglish,
                revelationType: revelationType,
                verseCount: verseCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int number,
                required String nameArabic,
                required String namePersian,
                required String nameEnglish,
                required String revelationType,
                required int verseCount,
              }) => SurahsCompanion.insert(
                id: id,
                number: number,
                nameArabic: nameArabic,
                namePersian: namePersian,
                nameEnglish: nameEnglish,
                revelationType: revelationType,
                verseCount: verseCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SurahsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurahsTable,
      Surah,
      $$SurahsTableFilterComposer,
      $$SurahsTableOrderingComposer,
      $$SurahsTableAnnotationComposer,
      $$SurahsTableCreateCompanionBuilder,
      $$SurahsTableUpdateCompanionBuilder,
      (Surah, BaseReferences<_$AppDatabase, $SurahsTable, Surah>),
      Surah,
      PrefetchHooks Function()
    >;
typedef $$VersesTableCreateCompanionBuilder =
    VersesCompanion Function({
      Value<int> id,
      required int surahId,
      required int verseNumber,
      required String textUthmani,
      required String textSimple,
      required int pageNumber,
      required int juzNumber,
    });
typedef $$VersesTableUpdateCompanionBuilder =
    VersesCompanion Function({
      Value<int> id,
      Value<int> surahId,
      Value<int> verseNumber,
      Value<String> textUthmani,
      Value<String> textSimple,
      Value<int> pageNumber,
      Value<int> juzNumber,
    });

class $$VersesTableFilterComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahId => $composableBuilder(
    column: $table.surahId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textUthmani => $composableBuilder(
    column: $table.textUthmani,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textSimple => $composableBuilder(
    column: $table.textSimple,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get juzNumber => $composableBuilder(
    column: $table.juzNumber,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VersesTableOrderingComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahId => $composableBuilder(
    column: $table.surahId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textUthmani => $composableBuilder(
    column: $table.textUthmani,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textSimple => $composableBuilder(
    column: $table.textSimple,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get juzNumber => $composableBuilder(
    column: $table.juzNumber,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VersesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahId =>
      $composableBuilder(column: $table.surahId, builder: (column) => column);

  GeneratedColumn<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textUthmani => $composableBuilder(
    column: $table.textUthmani,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textSimple => $composableBuilder(
    column: $table.textSimple,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get juzNumber =>
      $composableBuilder(column: $table.juzNumber, builder: (column) => column);
}

class $$VersesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VersesTable,
          Verse,
          $$VersesTableFilterComposer,
          $$VersesTableOrderingComposer,
          $$VersesTableAnnotationComposer,
          $$VersesTableCreateCompanionBuilder,
          $$VersesTableUpdateCompanionBuilder,
          (Verse, BaseReferences<_$AppDatabase, $VersesTable, Verse>),
          Verse,
          PrefetchHooks Function()
        > {
  $$VersesTableTableManager(_$AppDatabase db, $VersesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahId = const Value.absent(),
                Value<int> verseNumber = const Value.absent(),
                Value<String> textUthmani = const Value.absent(),
                Value<String> textSimple = const Value.absent(),
                Value<int> pageNumber = const Value.absent(),
                Value<int> juzNumber = const Value.absent(),
              }) => VersesCompanion(
                id: id,
                surahId: surahId,
                verseNumber: verseNumber,
                textUthmani: textUthmani,
                textSimple: textSimple,
                pageNumber: pageNumber,
                juzNumber: juzNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahId,
                required int verseNumber,
                required String textUthmani,
                required String textSimple,
                required int pageNumber,
                required int juzNumber,
              }) => VersesCompanion.insert(
                id: id,
                surahId: surahId,
                verseNumber: verseNumber,
                textUthmani: textUthmani,
                textSimple: textSimple,
                pageNumber: pageNumber,
                juzNumber: juzNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VersesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VersesTable,
      Verse,
      $$VersesTableFilterComposer,
      $$VersesTableOrderingComposer,
      $$VersesTableAnnotationComposer,
      $$VersesTableCreateCompanionBuilder,
      $$VersesTableUpdateCompanionBuilder,
      (Verse, BaseReferences<_$AppDatabase, $VersesTable, Verse>),
      Verse,
      PrefetchHooks Function()
    >;
typedef $$TranslationsTableCreateCompanionBuilder =
    TranslationsCompanion Function({
      Value<int> id,
      required int verseId,
      required String languageCode,
      required String authorName,
      required String translationText,
    });
typedef $$TranslationsTableUpdateCompanionBuilder =
    TranslationsCompanion Function({
      Value<int> id,
      Value<int> verseId,
      Value<String> languageCode,
      Value<String> authorName,
      Value<String> translationText,
    });

class $$TranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseId => $composableBuilder(
    column: $table.verseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationText => $composableBuilder(
    column: $table.translationText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseId => $composableBuilder(
    column: $table.verseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationText => $composableBuilder(
    column: $table.translationText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get verseId =>
      $composableBuilder(column: $table.verseId, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translationText => $composableBuilder(
    column: $table.translationText,
    builder: (column) => column,
  );
}

class $$TranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TranslationsTable,
          Translation,
          $$TranslationsTableFilterComposer,
          $$TranslationsTableOrderingComposer,
          $$TranslationsTableAnnotationComposer,
          $$TranslationsTableCreateCompanionBuilder,
          $$TranslationsTableUpdateCompanionBuilder,
          (
            Translation,
            BaseReferences<_$AppDatabase, $TranslationsTable, Translation>,
          ),
          Translation,
          PrefetchHooks Function()
        > {
  $$TranslationsTableTableManager(_$AppDatabase db, $TranslationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> verseId = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<String> translationText = const Value.absent(),
              }) => TranslationsCompanion(
                id: id,
                verseId: verseId,
                languageCode: languageCode,
                authorName: authorName,
                translationText: translationText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int verseId,
                required String languageCode,
                required String authorName,
                required String translationText,
              }) => TranslationsCompanion.insert(
                id: id,
                verseId: verseId,
                languageCode: languageCode,
                authorName: authorName,
                translationText: translationText,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TranslationsTable,
      Translation,
      $$TranslationsTableFilterComposer,
      $$TranslationsTableOrderingComposer,
      $$TranslationsTableAnnotationComposer,
      $$TranslationsTableCreateCompanionBuilder,
      $$TranslationsTableUpdateCompanionBuilder,
      (
        Translation,
        BaseReferences<_$AppDatabase, $TranslationsTable, Translation>,
      ),
      Translation,
      PrefetchHooks Function()
    >;
typedef $$TafsirsTableCreateCompanionBuilder =
    TafsirsCompanion Function({
      Value<int> id,
      required int verseId,
      required String editionName,
      required String languageCode,
      required String contentText,
    });
typedef $$TafsirsTableUpdateCompanionBuilder =
    TafsirsCompanion Function({
      Value<int> id,
      Value<int> verseId,
      Value<String> editionName,
      Value<String> languageCode,
      Value<String> contentText,
    });

class $$TafsirsTableFilterComposer
    extends Composer<_$AppDatabase, $TafsirsTable> {
  $$TafsirsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseId => $composableBuilder(
    column: $table.verseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TafsirsTableOrderingComposer
    extends Composer<_$AppDatabase, $TafsirsTable> {
  $$TafsirsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseId => $composableBuilder(
    column: $table.verseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TafsirsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TafsirsTable> {
  $$TafsirsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get verseId =>
      $composableBuilder(column: $table.verseId, builder: (column) => column);

  GeneratedColumn<String> get editionName => $composableBuilder(
    column: $table.editionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentText => $composableBuilder(
    column: $table.contentText,
    builder: (column) => column,
  );
}

class $$TafsirsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TafsirsTable,
          Tafsir,
          $$TafsirsTableFilterComposer,
          $$TafsirsTableOrderingComposer,
          $$TafsirsTableAnnotationComposer,
          $$TafsirsTableCreateCompanionBuilder,
          $$TafsirsTableUpdateCompanionBuilder,
          (Tafsir, BaseReferences<_$AppDatabase, $TafsirsTable, Tafsir>),
          Tafsir,
          PrefetchHooks Function()
        > {
  $$TafsirsTableTableManager(_$AppDatabase db, $TafsirsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TafsirsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TafsirsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TafsirsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> verseId = const Value.absent(),
                Value<String> editionName = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> contentText = const Value.absent(),
              }) => TafsirsCompanion(
                id: id,
                verseId: verseId,
                editionName: editionName,
                languageCode: languageCode,
                contentText: contentText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int verseId,
                required String editionName,
                required String languageCode,
                required String contentText,
              }) => TafsirsCompanion.insert(
                id: id,
                verseId: verseId,
                editionName: editionName,
                languageCode: languageCode,
                contentText: contentText,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TafsirsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TafsirsTable,
      Tafsir,
      $$TafsirsTableFilterComposer,
      $$TafsirsTableOrderingComposer,
      $$TafsirsTableAnnotationComposer,
      $$TafsirsTableCreateCompanionBuilder,
      $$TafsirsTableUpdateCompanionBuilder,
      (Tafsir, BaseReferences<_$AppDatabase, $TafsirsTable, Tafsir>),
      Tafsir,
      PrefetchHooks Function()
    >;
typedef $$BookmarksTableCreateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      required int surahId,
      required int verseNumber,
      Value<DateTime> createdAt,
      Value<String?> note,
    });
typedef $$BookmarksTableUpdateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      Value<int> surahId,
      Value<int> verseNumber,
      Value<DateTime> createdAt,
      Value<String?> note,
    });

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahId => $composableBuilder(
    column: $table.surahId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahId => $composableBuilder(
    column: $table.surahId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahId =>
      $composableBuilder(column: $table.surahId, builder: (column) => column);

  GeneratedColumn<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          Bookmark,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
          Bookmark,
          PrefetchHooks Function()
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahId = const Value.absent(),
                Value<int> verseNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => BookmarksCompanion(
                id: id,
                surahId: surahId,
                verseNumber: verseNumber,
                createdAt: createdAt,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahId,
                required int verseNumber,
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => BookmarksCompanion.insert(
                id: id,
                surahId: surahId,
                verseNumber: verseNumber,
                createdAt: createdAt,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      Bookmark,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (Bookmark, BaseReferences<_$AppDatabase, $BookmarksTable, Bookmark>),
      Bookmark,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$VersesTableTableManager get verses =>
      $$VersesTableTableManager(_db, _db.verses);
  $$TranslationsTableTableManager get translations =>
      $$TranslationsTableTableManager(_db, _db.translations);
  $$TafsirsTableTableManager get tafsirs =>
      $$TafsirsTableTableManager(_db, _db.tafsirs);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
}
