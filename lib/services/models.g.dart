// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game()
  ..players = (json['players'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList()
  ..rounds = (json['rounds'] as List<dynamic>)
      .map((e) => Round.fromJson(e as Map<String, dynamic>))
      .toList()
  ..dealer = json['dealer'] == null
      ? null
      : Player.fromJson(json['dealer'] as Map<String, dynamic>)
  ..currentRound = json['currentRound'] as int;

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'players': instance.players,
      'rounds': instance.rounds,
      'dealer': instance.dealer,
      'currentRound': instance.currentRound,
    };

Round _$RoundFromJson(Map<String, dynamic> json) => Round()
  ..currentTrick = json['currentTrick'] as int
  ..predictions = (json['predictions'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(int.parse(k), e as int),
  )
  ..results = (json['results'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(int.parse(k), e as int),
  );

Map<String, dynamic> _$RoundToJson(Round instance) => <String, dynamic>{
      'currentTrick': instance.currentTrick,
      'predictions':
          instance.predictions.map((k, e) => MapEntry(k.toString(), e)),
      'results': instance.results.map((k, e) => MapEntry(k.toString(), e)),
    };

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      name: json['name'] as String? ?? 'Tap to edit',
      points: json['points'] as int? ?? 0,
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'name': instance.name,
      'points': instance.points,
    };
