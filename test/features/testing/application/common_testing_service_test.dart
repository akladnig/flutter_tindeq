import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tindeq/src/features/testing/application/common_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';

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

// squareWave sublist testing
  group('squareWave sublist(1,29)', () {
    test('edgeList(1, 29)', () {
      expect(
        squareWave.sublist(1, 29).edgeIndexList(EdgeType.rising),
        [(1, 5)],
      );
    });
    test('rfdIndexList(1, 29)', () {
      expect(
        squareWave.sublist(1, 29).rfdIndexList(EdgeType.rising)[0],
        3,
      );
    });
    test('getEdge (1, 29)', () {
      expect(
        squareWave.sublist(1, 29).getEdge,
        (3, 0),
      );
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
        'getEdge(20, 90) - get the first rising and falling edge from a subset(20, 90) of the edge data',
        () {
      expect(
        squareWave.sublist(20, 90).getEdge,
        (34, 9),
      );
    });

    test(
        'getEdge(0, 900) - get the first rising and falling edge from a subset(20, 90) of the edge data',
        () {
      expect(
        pointListCft.sublist(0, 900).getEdge,
        (46, 599),
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

  //toPoint
  test('toPoint', () {
    expect(
      squareWave.toPoint(0),
      (-0.08, 1.206029211),
    );
  });

  //rfdIndexList - length
  group('refIndexLength', () {
    test('rfdIndexList rising Length - pointListCft', () {
      expect(
        pointListCft.sublist(14344, 20085).rfdIndexList(EdgeType.rising).length,
        6,
      );
    });

    test('rfdIndexList falling Length - pointListCft', () {
      expect(
        pointListCft.rfdIndexList(EdgeType.falling).length,
        27,
      );
    });
  });

  test('rfdIndexList falling Length - pointListCft', () {
    expect(
      pointListCft
          .toPointList(
              pointListCft.sublist(16502, 20085).rfdIndexList(EdgeType.falling),
              16502)
          .length,
      4,
    );
  });

  test('rfdIndexList of rising edges - pointListCft', () {
    expect(
      pointListCft.toPointList(pointListCft.rfdIndexList(EdgeType.rising)),
      [
        (0.602761, 17.064092082977297),
        (10.245003, 16.84762899398804), //
        (10.816884, 22.41489736557007), //
        (21.222926, 11.449510974884033),
        (31.405975, 8.90670244216919),
        (41.422792, 12.172501964569092), //
        (41.591038, 18.145390911102297), //
        (51.204247, 12.507395191192627), //
        (54.760294, 20.265201015472414), ////
        (61.199096, 5.657259864807129), //
        (64.956909, 22.16552869796753), ////
        (71.07055, 6.935842914581299),
        (81.378712, 6.047838611602783),
        (91.05975, 8.317961139678955),
        (101.570025, 11.85775987625122),
        (111.204341, 11.287953777313232),
        (121.568327, 6.336490077972412), //
        (121.848827, 13.700405521392822), //
        (131.449874, 8.291968746185303),
        (141.802256, 6.823156757354736), //
        (142.015341, 11.29652063369751), //
        (151.46982, 4.2166322898864745),
        (161.698586, 6.981793804168701),
        (171.637584, 4.491897506713867),
        (181.484453, 6.307673854827881),
        (191.746426, 5.024076862335205),
        (201.573303, 5.814289970397949),
        (211.701046, 8.320054454803467),
        (221.75019, 7.448113842010498),
        (231.844218, 7.840494556427002)
      ],
    );
  });

  test('rfdIndexList of falling edges - pointListCft', () {
    expect(
      pointListCft.toPointList(pointListCft.rfdIndexList(EdgeType.falling)),
      [
        (7.228497, 20.38562719345093),
        (10.502913, 19.633916301727297), //
        (17.230757, 16.53522436141968),
        (27.278259, 16.45987264633179),
        (36.195804, 23.290294094085695), //
        (38.147641, 13.199087543487549), //
        (47.670754, 8.0375856590271),
        (56.925331, 20.70659772872925), //
        (57.374007, 7.668666286468506), //
        (67.839954, 13.278088970184326),
        (77.508731, 6.9732755851745605),
        (87.515336, 9.970963878631592),
        (97.823692, 8.893949909210205),
        (107.570334, 8.44223253250122),
        (117.485333, 12.88785020828247),
        (127.535588, 7.671587390899658),
        (137.607913, 9.210589809417725),
        (147.577876, 8.215740604400635),
        (157.514969, 7.154400272369385),
        (167.464271, 6.594962520599365),
        (177.649206, 7.468460483551025),
        (187.641535, 9.104669971466064),
        (197.691744, 8.860606594085693),
        (207.786771, 8.174415035247803),
        (218.351736, 8.468760890960693),
        (227.750527, 8.344051761627197),
        (237.586638, 7.780817432403564)
      ],
    );
  });

//edgeList
  group('edgeList', () {
    test('edgeList - a flat line returns an empty list', () {
      expect(
        flatLine1.edgeIndexList(EdgeType.rising),
        [],
      );
    });

    test('edgeList - get a list of rising edges', () {
      expect(
        squareWave.edgeIndexList(EdgeType.rising),
        [(2, 6), (52, 56)],
      );
    });

    test(
        'edgeList(5, 29) - there is no edgeList with greater than 5 points so should be empty',
        () {
      expect(
        squareWave.sublist(5, 29).edgeIndexList(EdgeType.rising),
        [],
      );
    });

    test('edgeList(34, 99)', () {
      expect(
        squareWave.sublist(34, 99).edgeIndexList(EdgeType.rising),
        [(18, 22)],
      );
    });

    test('edgeList falling - pointListCft', () {
      expect(
        pointListCft.edgeIndexList(EdgeType.falling),
        [
          (582, 614),
          (863, 879), // In Middle
          (1422, 1444),
          (2255, 2283),
          (3005, 3024),
          (3161, 3186), // Diff of 137
          (3945, 3981),
          (4739, 4761),
          (4762, 4789), // Diff of 1
          (5640, 5673),
          (6433, 6470),
          (7270, 7309),
          (8145, 8168),
          (8949, 8979),
          (9766, 9810),
          (10618, 10646),
          (11450, 11492),
          (12287, 12319),
          (13113, 13144),
          (13942, 13971),
          (14791, 14827),
          (15627, 15660),
          (16472, 16502),
          (17307, 17347),
          (18186, 18231),
          (18976, 19011),
          (19793, 19829)
        ],
      );
    });

    test('edgeList - pointListCft', () {
      expect(
        pointListCft.edgeIndexList(EdgeType.rising),
        [
          (14, 74),
          (830, 857),
          (879, 900), // Diff of 22
          (1759, 1789),
          (2611, 2642),
          (3443, 3455),
          (3457, 3480), // Diff of 2
          (4250, 4290),
          (4529, 4574), // Big diff - mid peak
          (5098, 5143),
          (5391, 5422), // Big diff - mid peak
          (5921, 5960),
          (6780, 6821),
          (7575, 7628),
          (8444, 8491),
          (9250, 9304),
          (10130, 10150),
          (10152, 10171), // Diff of 2
          (10947, 11001),
          (11818, 11831),
          (11833, 11879), // Diff of 2
          (12628, 12677),
          (13471, 13510),
          (14308, 14343),
          (15125, 15181),
          (15984, 16027),
          (16800, 16859),
          (17633, 17666),
          (18486, 18499),
          (19318, 19373)
        ],
      );
    });

    test('edgeList(20, 90)', () {
      expect(
        squareWave.sublist(20, 90).edgeIndexList(EdgeType.rising),
        [(32, 36)],
      );
    });
  });

//fallingList
  test('fallingList - get a list of falling edges', () {
    expect(
      squareWave.edgeIndexList(EdgeType.falling),
      [(27, 31), (77, 81)],
    );
  });

//isOnEdge
  group('isOnEdge', () {
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
  });
}
