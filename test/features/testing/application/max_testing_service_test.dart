import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tindeq/src/features/testing/application/common_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/application/max_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';

void main() {
  // var testPoints = MaxTesting([
  var testPoints = PointListClass([
    (5.339800000000000102e-02, 2.509890956878662038e-02),
    (5.339800000000000102e-02, -2.509890956878662038e-02),
    (6.460499999999999576e-02, 0.000000000000000000e+00),
    (7.581200000000000438e-02, 2.505363864898681570e+02),
    (8.702000000000000013e-02, 2.599999999999999999e+00),
    (9.822699999999999487e-02, 2.493730468749999929e+00),
    (1.094350000000000045e-01, 2.506629390716552663e+00),
    (1.206440000000000012e-01, 2.513006134033203054e+00),
    (1.318529999999999980e-01, 2.511448307037353445e+00),
    (1.430619999999999947e-01, 2.513054771423339773e+00),
  ]);

  var flatLine1 = PointListClass([
    (1.0, 3.1),
    (2.0, 3.1),
    (3.0, 3.1),
    (4.0, 3.1),
    (5.0, 3.1),
  ]);

  var squareWave = PointListClass([
    (-0.08, 1.206029211),
    (-0.06, 0.712331731),
    (-0.04, 3.105896908),
    // (-0.04, 1.925896908),
    (-0.02, 5.243282114),
    (0, 10),
    (0.02, 13.65598468),
    (0.04, 16.67083559),
    (0.06, 18.59944873),
    (0.08, 19.31986301),
    (0.1, 19.04804091),
    (0.12, 18.23827803),
    (0.14, 17.40886498),
    (0.16, 16.95894367),
    (0.18, 17.04373373),
    (0.2, 17.55128099),
    (0.22, 18.18401659),
    (0.24, 18.60808948),
    (0.26, 18.60808948),
    (0.28, 18.18401659),
    (0.3, 17.55128099),
    (0.32, 17.04373373),
    (0.34, 16.95894367),
    (0.36, 17.40886498),
    (0.38, 18.23827803),
    (0.4, 19.04804091),
    (0.42, 19.31986301),
    (0.44, 18.59944873),
    (0.46, 16.67083559),
    (0.48, 13.65598468),
    (0.5, 10),
    (0.52, 6.344015317),
    (0.54, 3.329164409),
    (0.56, 1.400551266),
    (0.58, 0.680136993),
    (0.6, 0.951959089),
    (0.62, 1.761721969),
    (0.64, 2.591135024),
    (0.66, 3.041056332),
    (0.68, 2.95626627),
    (0.7, 2.448719011),
    (0.72, 1.815983406),
    (0.74, 1.391910519),
    (0.76, 1.391910519),
    (0.78, 1.815983406),
    (0.8, 2.448719011),
    (0.82, 2.95626627),
    (0.84, 3.041056332),
    (0.86, 2.591135024),
    (0.88, 1.761721969),
    (0.9, 0.951959089),
    (0.92, 0.680136993),
    (0.94, 1.400551266),
    (0.96, 3.329164409),
    (0.98, 6.344015317),
    (1, 10),
    (1.02, 13.65598468),
    (1.04, 16.67083559),
    (1.06, 18.59944873),
    (1.08, 19.31986301),
    (1.1, 19.04804091),
    (1.12, 18.23827803),
    (1.14, 17.40886498),
    (1.16, 16.95894367),
    (1.18, 17.04373373),
    (1.2, 17.55128099),
    (1.22, 18.18401659),
    (1.24, 18.60808948),
    (1.26, 18.60808948),
    (1.28, 18.18401659),
    (1.3, 17.55128099),
    (1.32, 17.04373373),
    (1.34, 16.95894367),
    (1.36, 17.40886498),
    (1.38, 18.23827803),
    (1.4, 19.04804091),
    (1.42, 19.31986301),
    (1.44, 18.59944873),
    (1.46, 16.67083559),
    (1.48, 13.65598468),
    (1.5, 10),
    (1.52, 6.344015317),
    (1.54, 3.329164409),
    (1.56, 1.400551266),
    (1.58, 0.680136993),
    (1.6, 0.951959089),
    (1.62, 1.761721969),
    (1.64, 2.591135024),
    (1.66, 3.041056332),
    (1.68, 2.95626627),
    (1.7, 2.448719011),
    (1.72, 1.815983406),
    (1.74, 1.391910519),
    (1.76, 1.391910519),
    (1.78, 1.815983406),
    (1.8, 2.448719011),
    (1.82, 2.95626627),
    (1.84, 3.041056332),
    (1.86, 2.591135024),
    (1.88, 1.761721969),
    (1.9, 0.951959089),
  ]);

  var fixedPoints = ([
    (5.339800000000000102e-02, 0.000000000000000000e+00),
    (5.339800000000000102e-02, 0.000000000000000000e+00),
    (6.460499999999999576e-02, 0.0),
    (7.581200000000000438e-02, 2.505e+02),
    (8.702000000000000013e-02, 2.6e+00),
    (9.822699999999999487e-02, 2.5e+00),
    (1.094350000000000045e-01, 2.5e+00),
    (1.206440000000000012e-01, 2.5e+00),
    (1.318529999999999980e-01, 2.5e+00),
    (1.430619999999999947e-01, 2.5e+00),
  ]);

  var forceList = [
    2.509890956878662038e-02,
    -2.509890956878662038e-02,
    0.000000000000000000e+00,
    2.505363864898681570e+02,
    2.599999999999999999e+00,
    2.493730468749999929e+00,
    2.506629390716552663e+00,
    2.513006134033203054e+00,
    2.511448307037353445e+00,
    2.513054771423339773e+00,
  ];

  var timeList = [
    5.339800000000000102e-02,
    5.339800000000000102e-02,
    6.460499999999999576e-02,
    7.581200000000000438e-02,
    8.702000000000000013e-02,
    9.822699999999999487e-02,
    1.094350000000000045e-01,
    1.206440000000000012e-01,
    1.318529999999999980e-01,
    1.430619999999999947e-01,
  ];

  // length
  test('list length is 10', () {
    expect(testPoints.length, 10);
  });

  // toFixed
  test(
      'tofixed correctly converts a list of doubles to a list of single decimal point',
      () {
    expect(testPoints.toFixed, fixedPoints);
  });

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

  // maxStrength
  group('maxStrength', () {
    test('maxStrength gets the maximum point from a list', () {
      expect(testPoints.maxStrength,
          ((time: 7.581200000000000438e-02, force: 2.505363864898681570e+02)));
    });
    test('maxStrength gets the maximum point from the squareWave', () {
      expect(squareWave.maxStrength, ((time: 0.08, force: 19.31986301)));
    });
  });

  // isEdgePoint - point >= TriggerLevel and <= maxLevel
  group('isEdgePoint', () {
    test('isEdgePoint (1, 2.99) is below triggerLevel', () {
      expect(squareWave.isEdgePoint((1.0, 2.99), 10), false);
    });
    test('isEdgePoint (1, 3.0) is above triggerLevel', () {
      expect(squareWave.isEdgePoint((1.0, 3.0), 10), true);
    });
    test('isEdgePoint (1, 9.9) is below maxLevel', () {
      expect(squareWave.isEdgePoint((1.0, 9.9), 10), true);
    });
    test('isEdgePoint (1, 10.1) is above maxLevel', () {
      expect(squareWave.isEdgePoint((1.0, 10.1), 10), false);
    });
  });

  test('isSequential', () {
    expect(
        isSequential(
            [1.400551266, 0.680136993, 0.951959089, 1.761721969, 2.591135024],
            Sequence.increment),
        false);
  });
//subList
  test('subList', () {
    expect(squareWave.sublist(0, 5), [
      (-0.08, 1.206029211),
      (-0.06, 0.712331731),
      (-0.04, 3.105896908),
      (-0.02, 5.243282114),
      (0, 10),
    ]);
  });
  test('subList', () {
    expect(squareWave.sublist(1, 8 + 1), [
      (-0.06, 0.712331731),
      (-0.04, 3.105896908),
      (-0.02, 5.243282114),
      (0, 10),
      (0.02, 13.65598468),
      (0.04, 16.67083559),
      (0.06, 18.59944873),
      (0.08, 19.31986301),
    ]);
  });

//getEdges
  group('getEdges', () {
    test('getEdges- a flat line returns an empty list', () {
      expect(
        flatLine1.getEdges,
        (0, 0),
      );
    });

    test('getEdges- get a list of rising edges', () {
      expect(
        squareWave.getEdges,
        (4, 29),
      );
    });

    test('getEdges (1, 29)', () {
      expect(
        squareWave.sublist(1, 29).getEdges,
        (3, 0),
      );
    });
    test('getEdges (34, 99)', () {
      expect(
        squareWave.sublist(34, 99).getEdges,
        (20, 45),
      );
    });

    test(
        'getEdges (5, 29)- there is no edgeList with greater than 5 points so should be empty',
        () {
      expect(
        squareWave.sublist(5, 29).getEdges,
        (0, 0),
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

  // getEdge
  group('getEdge', () {
    test('getEdge - get the first rising edge', () {
      expect(squareWave.getEdge, (4, 29));
    });

    // PointListClass sublist = PointListClass(squareWave.sublist(0, 20));
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

  // mean
  test('mean', () {});

  // meanLine
  test('meanLine', () {});

  // maxResult
  test('maxResult', () {});
}
