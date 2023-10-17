import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tindeq/src/features/testing/application/common_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/application/max_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';

import '../repository/test_data.dart';

void main() {
  // subListByType
  group('subListByType', () {
    test('subListByType returns complete force list', () {
      expect(testPoints.subListByType(ListType.force), forceList);
    });

    test('subListByType returns complete time list', () {
      expect(testPoints.subListByType(ListType.time), timeList);
    });

    test('subListByType(time, 0, 2) returns first 3 time list elements', () {
      expect(testPoints.subListByType(ListType.time, start: 0, end: 2), [
        5.339800000000000102e-02,
        5.339800000000000102e-02,
        6.460499999999999576e-02,
      ]);
    });

    test('subListByType(time, 7, 9) returns last 3 time list elements', () {
      expect(testPoints.subListByType(ListType.time, start: 7, end: 9), [
        1.206440000000000012e-01,
        1.318529999999999980e-01,
        1.430619999999999947e-01,
      ]);
    });
  });

//getEdge
  group('getEdge', () {
    test('getEdge- a flat line returns an empty list', () {
      expect(
        flatLine1.getEdge,
        (0, 0),
      );
    });

    test('getEdge- get a list of rising edges', () {
      expect(
        squareWave.getEdge,
        (4, 29),
      );
    });

    test('getEdge (1, 29)', () {
      expect(
        squareWave.sublist(1, 29).getEdge,
        (3, 0),
      );
    });
    test('getEdge (34, 99)', () {
      expect(
        squareWave.sublist(34, 99).getEdge,
        (20, 45),
      );
    });

    test(
        'getEdge (5, 29)- there is no edgeList with greater than 5 points so should be empty',
        () {
      expect(
        squareWave.sublist(5, 29).getEdge,
        (0, 0),
      );
    });

    test('getEdge - get the first rising edge', () {
      expect(squareWave.getEdge, (4, 29));
    });

    test(
        'getEdge - get the first rising edge from a subset(0, 20) of the edge data',
        () {
      expect(
        squareWave.sublist(0, 20).getEdge,
        (4, 0),
      );
    });

    test(
        'getEdge - get the first rising and falling edge from a subset(20, 90) of the edge data',
        () {
      expect(
        squareWave.sublist(20, 90).getEdge,
        (34, 9),
      );
    });

    test(
        'getEdge - only contains a falling edge from subset (8, 33) of the edge data',
        () {
      expect(
        squareWave.sublist(8, 33).getEdge,
        (0, 21),
      );
    });
  });

//edgeList
  group('edgeList', () {
    test('edgeList - a flat line returns an empty list', () {
      expect(
        flatLine1.edgeList(EdgeType.rising),
        [],
      );
    });

    test('edgeList - get a list of rising edges', () {
      expect(
        squareWave.edgeList(EdgeType.rising),
        [(2, 6), (52, 56)],
      );
    });

    test(
        'edgeList(5, 29) - there is no edgeList with greater than 5 points so should be empty',
        () {
      expect(
        squareWave.sublist(5, 29).edgeList(EdgeType.rising),
        [],
      );
    });

    test('edgeList(34, 99)', () {
      expect(
        squareWave.sublist(34, 99).edgeList(EdgeType.rising),
        [(18, 22)],
      );
    });
  });

//fallingList
  test('fallingList - get a list of falling edges', () {
    expect(
      squareWave.edgeList(EdgeType.falling),
      [(27, 31), (77, 81)],
    );
  });

//isOnEdge
  test('isOnEdge', () {
    expect(
      squareWave.isOnEdge((0.42, 19.31986301)),
      false,
    );
  });

  test('isOnEdge', () {
    expect(
      squareWave.isOnEdge((0.46, 16.67083559)),
      true,
    );
  });
}
