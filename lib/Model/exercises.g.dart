// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercises.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseSetAdapter extends TypeAdapter<ExerciseSet> {
  @override
  final int typeId = 1;

  @override
  ExerciseSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseSet()
      ..weight = fields[0] as double
      ..reps = fields[1] as int
      ..distance = fields[2] as double
      ..duration = fields[3] as Duration;
  }

  @override
  void write(BinaryWriter writer, ExerciseSet obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.weight)
      ..writeByte(1)
      ..write(obj.reps)
      ..writeByte(2)
      ..write(obj.distance)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseDayLogAdapter extends TypeAdapter<ExerciseDayLog> {
  @override
  final int typeId = 2;

  @override
  ExerciseDayLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseDayLog(
      date: fields[1] as DateTime,
    )
      ..sets = (fields[0] as List).cast<ExerciseSet>()
      ..maxWeightIndex = fields[2] as int
      ..maxRepsIndex = fields[3] as int
      ..maxDistanceIndex = fields[4] as int
      ..maxDurationIndex = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, ExerciseDayLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.sets)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.maxWeightIndex)
      ..writeByte(3)
      ..write(obj.maxRepsIndex)
      ..writeByte(4)
      ..write(obj.maxDistanceIndex)
      ..writeByte(5)
      ..write(obj.maxDurationIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseDayLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
