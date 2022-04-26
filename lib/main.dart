import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart' show useResult;

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

/* mixin can put constraint on their implementing classes to say for instance I'm a mixin and I need this property of this type. any object that uses me as a mixin have to have this property too. so it's kind
of like abstract classes that they can put constraint on their implementing classes. */
/* this mixin is not useful alone and should call in other classes to see how it works. */
mixin CanRun {
  int get speed;
  void run() {
    "Running at the speed of: $speed".log();
  }
}

abstract class Animal {
  const Animal();
}

mixin CanWalk on Animal {
  int get speed;
  void run() {
    "Walking at the speed of: $speed".log();
  }
}

/* cat class can inherit the mixin with "with" keyword.*/
/* in OOP languages there is only one super class. however with mixin we can have multiple mixins into the same class using the "with" keyword. */
class Cat with CanRun {
  @override
  int speed = 10;
}

/* the way we can inherit from both mixin and abstract class comes on the next line. because any class in Dart implicitly of the type Object even though you don't say extend object it is defaul of type object.
so if we remove "extends Animal" the class dog can not work any more and we have an error which shows Dart is not happy about our implementation. */
class Dog extends Animal with CanWalk {
  @override
  int speed = 5;
}

extension GetUri on Object {
  Future<HttpClientResponse> getUrl(String url) =>
      HttpClient().getUrl(Uri.parse(url)).then((req) => req.close());
}

/* this mixin is exactly like the CanRun mixin, CanRun gives an integer and return speed, here you will pass the URL String and get the result. */
/* I prefer to only use the result of this particular class in mixin by adding "useResult" meta tag to use the result of the function */
/* for this purpose I used "Live Server" extension for "VSCode" and instead of using live server load the names from the "api" folder which contains a json file as a hard coded json object. so press
"cmd + shift + p" on mac or "ctrl + shift + p" on windows or linux and type live server and select on "open live server" and go to api/people.json, the url is your base url. (http://127.0.0.1:5500/api/people.json) */
mixin CanMakeGetCall {
  String get url;
  @useResult
  Future<String> getString() =>
      getUrl(url).then((res) => res.transform(utf8.decoder).join());
}

@immutable
class GetPeople with CanMakeGetCall {
  const GetPeople();
  @override
  String get url => "http://127.0.0.1:5500/api/people.json";
}

/* getString method comes to people from the mixin class which we defined before. so we passed the url in People class and when we get an instance of People class we have access to mixin functions and properties
and we're able to call getString method and parse our json file in utf8 format which we defined in our extension */
void tester() async {
  final cat = Cat();
  cat.run();
  cat.speed = 20;
  cat.run();
  final people = await const GetPeople().getString();
  people.log();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    tester();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
    );
  }
}
