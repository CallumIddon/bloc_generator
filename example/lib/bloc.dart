import "dart:async";
import "package:rxdart/rxdart.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc_annotations/flutter_bloc_annotations.dart";
import "package:flutter_bloc_example/services.dart";
part "bloc.bloc.dart";

@BLoC()
@BLoCService("SetService", "setCounter")
@BLoCService("PrintService", "counter")
class _Test {
	@BLoCInput()
	StreamController<int> setCounter = StreamController<int>();
	@BLoCInput()
	StreamController<int> addToCounter = StreamController<int>();

	@BLoCOutput()
	BehaviorSubject<String> counter = BehaviorSubject<String>(seedValue: "0");

	@BLoCValue("counter")
	String currentCounter;

	@BLoCMapper("setCounter", "counter")
	Future<String> setCounterBLoC(int intputData) async => intputData.toString();

	@BLoCMapper("addToCounter", "counter")
	Future<String> setAddToCounterBLoC(int inputData) async =>
		(int.parse(currentCounter) + inputData).toString();
}