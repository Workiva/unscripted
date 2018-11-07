library io_test;

import 'dart:io';

import 'package:unscripted/unscripted.dart';
import 'package:unscripted/src/util.dart';
import 'package:test/test.dart';

main() {
  group('io', () {
    group('Input', () {
      group('stdin', () {
        Input unit;

        setUp(() {
          unit = parseInput('-');
        });

        test('stream', () {
          expect(unit.stream, stdin);
        });

        test('path', () {
          expect(unit.path, isNull);
        });
      });

      group('file', () {
        Input unit;

        setUp(() {
          unit = parseInput('test/fixtures/foo.txt');
        });

        test('stream', () {
          expect(unit.stream.isEmpty, completion(isFalse));
        });

        test('path', () {
          expect(unit.path, endsWith('foo.txt'));
        });
      });
    });
    group('Output', () {
      group('stdin', () {
        Output unit;

        setUp(() {
          unit = parseOutput('-');
        });

        test('stream', () {
          expect(unit.sink, stdout);
        });

        test('path', () {
          expect(unit.path, isNull);
        });
      });

      group('file', () {
        Output unit;
        File file;
        String filename = 'test/fixtures/bar.txt';
        setUp(() {
          file = new File(filename);
          file.createSync();
          unit = parseOutput(filename);
        });

        test('sink', () {
          unit.sink.write('bar');
          return unit.sink.close().then((_) {
            expect(file.readAsStringSync(), 'bar');
          });
        });

        test('path', () {
          expect(unit.path, endsWith('bar.txt'));
        });

        tearDown(() {
          return file.delete();
        });
      });
    });
  });
}
