package;

using StringTools;

class BeatSync
{
	public static function getSongPos(song:String = ''):Array<Int>
	{
		switch (song)
		{
			case 'pico':
				return [
					3314, 3898, 4435, 4800, 5377, 5953, 6329, 6514, 7058, 7683, 8033, 8608, 9073, 9505, 9707, 10265, 10850, 11202, 11809, 12507, 12770, 12937,
					13529, 14073, 14450, 14992, 15498, 15722, 16083, 16771, 17299, 17656, 19265, 20449, 20889, 21728, 22130, 22322, 22522, 24065, 25248,
					25643, 26314, 27266, 28081, 28457, 28692, 28891, 30033, 30530, 31114, 31691, 32089, 32737, 33354, 33689, 34280, 34873, 35289, 35890,
					36425, 36913, 37498, 38080, 38497, 39065, 39702, 40063, 40671, 41239, 41655, 43263, 44510, 44864, 45583, 46519, 47336, 47744, 47926,
					48119, 48847, 49696, 51231, 52855, 53702, 54102, 54471, 55232, 56063, 57680, 58943, 59256, 60118, 60481, 60688, 60897, 62560, 64088,
					65720, 66911, 67303, 67922, 68521, 68872, 69426, 70079, 70498, 71232, 71721, 72127, 72694, 73308, 73565, 73740, 74259, 74893, 75293,
					75824, 76514, 76904, 77464, 77927, 78466, 79121, 79608, 80048
				];
			case 'philly':
				return [
					3104, 3646, 3840, 4567, 5239, 5968, 6624, 7287, 7984, 8368, 9248, 9743, 10048, 10320, 10607, 10727, 11112, 11424, 11767, 11968, 12391,
					12774, 13137, 13464, 14112, 14632, 14815, 15174, 15527, 15975, 16184, 16561, 16742, 16935, 17392, 17584, 17855, 17985, 18286, 18593,
					18903, 19079, 19334, 19669, 19869, 20192, 20386, 20709, 21037, 21230, 21506, 21737, 22080, 22351, 22543, 22889, 23071, 23336, 23440,
					23719, 24073, 24471, 24655, 24840, 25464, 25800, 26518, 27191, 27886, 28550, 29239, 29934, 30599, 31264, 31943, 32616, 33286, 33967,
					34336, 34657, 35028, 35388, 35570, 35781, 36116, 36756, 37132, 37484, 38077, 38243, 38542, 38835, 39380, 39556, 39918, 40221, 40781,
					40963, 41132, 41295, 41614, 42118, 42296, 42608, 42951, 43541, 43685, 44006, 44342, 44909, 45062, 45422, 45693, 46085, 46263, 46431,
					46593, 46775, 47085, 47575, 47752, 48101, 48463, 49037, 49208, 49485, 49815, 50319, 50513, 50822, 51035, 51450, 51873, 52220, 52402,
					52571, 52900, 53275, 53611, 53796, 53978, 54138, 54537, 54697, 54995, 55291, 55465, 55804, 55987, 56329, 56690, 57019, 57378, 57689,
					58219, 59065, 59585, 60475, 61025, 61845, 62402, 63139, 63643, 64500, 65013, 65860, 66394, 67195, 67717, 68316, 68674, 69028, 70029,
					70484, 71308, 71848, 72720, 73266, 73777, 74137, 74493, 75439, 76000, 76838, 77357, 78254, 78757, 79278, 79637, 80030, 80494, 80686,
					80998, 81323, 81875, 82074, 82402, 82713, 83220, 83405, 83772, 84099, 84603, 84781, 84966, 85149, 85444, 85980, 86156, 86509, 86852,
					87380, 87572, 87876, 88206, 88692, 88875, 89229, 89564, 89973, 90165, 90567
				];
			case 'blammed':
				return [
					11679, 12750, 13493, 14583, 15191, 15701, 16439, 17509, 18589, 19367, 20453, 21005, 21551, 22295, 24478, 25182, 26271, 26821, 27374,
					28110, 29134, 30231, 31015, 32046, 32653, 33239, 33951, 34950, 36446, 36685, 37932, 38116, 38310, 39326, 39525, 40854, 41037, 41405,
					42238, 42445, 42637, 43727, 43924, 44837, 45165, 45571, 45964, 46141, 46326, 46669, 47419, 47764, 48477, 48837, 49030, 49237, 49412,
					49580, 50053, 50245, 50598, 50788, 51140, 51349, 51772, 51941, 52132, 52299, 52469, 53237, 53572, 54333, 54654, 55029, 55204, 55382,
					55860, 56061, 56389, 56572, 56933, 57093, 57573, 57926, 58278, 58605, 59005, 59371, 59805, 60180, 61200, 61760, 62273, 63048, 63416,
					63598, 63775, 63968, 64167, 64904, 65189, 65964, 66299, 67013, 67621, 68124, 68628, 68812, 69220, 69411, 69581, 69747, 70018, 71332,
					71523, 71709, 72804, 73011, 73213, 74282, 74475, 74668, 75762, 75938, 76115, 77205, 77413, 78645, 78828, 79004, 80091, 80325, 80853,
					81044, 81227, 81387, 82980, 83562, 84490, 85028, 85580, 85915, 86453, 86961, 87425, 87592, 87777, 88408, 88831, 89017, 89232, 89832,
					90329, 90505, 90704, 91024, 91386, 91728, 91937, 92465, 92648, 92832, 93048, 93232
				];
			case 'satin-panties':
				return [
					213, 1629, 1756, 1908, 2054, 2196, 3507, 3606, 3724, 3934, 4069, 4227, 4413, 4534, 5061, 5318, 5828, 6101, 6619, 7053, 7213, 7475, 7635,
					7963, 8341, 8836, 9275, 9421, 9708, 10149, 10468, 10957, 11381, 11540, 11891, 12140, 12580, 12708, 12900, 13123, 13236, 13749, 14036,
					14628, 14877, 15381, 15788, 15948, 16196, 16716, 17002, 17532, 17900, 18042, 18330, 18979, 19236, 19739, 20067, 20252, 20564, 20828,
					20956, 21291, 21404, 21607, 21826, 21938, 22451, 22634, 23235, 23507, 24028, 24506, 24650, 24882, 25490, 25793, 26274, 26738, 27044,
					27650, 27915, 28433, 28887, 29063, 29294, 29595, 29722, 29862, 30017, 30189, 30309, 30453, 30614, 30716, 31211, 31477, 32068, 32295,
					32797, 33397, 33685, 34190, 34452, 35020, 35420, 35533, 35804, 36372, 36668, 37253, 37589, 37739, 37998, 38276, 38405, 38541, 38796,
					38931, 39077, 39300, 39405, 39903, 40176, 40762, 41039, 41516, 42068, 42379, 43203, 43404, 43690, 43804, 44164, 44283, 44532, 45084,
					45387, 45868, 46370, 46708, 47149, 47299, 47546, 47669, 47914, 48058, 48636, 48898, 49498, 49721, 50289, 50682, 50827, 51096, 51218,
					51624, 51921, 52482, 52835, 52985, 53258, 53888, 54129, 54618, 54985, 55122, 55481, 55728, 55841, 55985, 56267, 56393, 56513, 56722,
					56832, 57384, 57529, 57665, 57863, 58208, 58480, 58929, 59415, 59543, 59801, 60337, 60663, 61178, 61770, 62337, 62665, 62856, 63319,
					63950, 64512, 65009, 65321, 65496, 65599, 66082, 66376, 66953, 67218, 67724, 68261, 68581, 69099, 69403, 69961, 70384, 70507, 70763,
					71321, 71587, 72104, 72496, 72639, 72902, 73151, 73287, 73413, 73704, 73830, 73974, 74174, 74279, 74823, 75119, 75662, 75959, 76438,
					77040, 77305, 77857, 78148, 78554, 78675, 79132, 79475, 80037, 80333, 80843, 81268, 81392, 81655, 81911, 82023, 82134, 82439, 82543,
					82839, 82968, 83544, 83822, 84089, 84376, 84663, 84910, 85151, 85709, 85982, 86270, 86566, 86871, 87115, 87387
				];
			case 'milf':
				return [
					2644, 3045, 3363, 3724, 4092, 4476, 4810, 5132, 5459, 5828, 6131, 6499, 6795, 7139, 7483, 7778, 7875, 7989, 8116, 8421, 8732, 9133, 9493,
					9813, 10140, 10469, 10814, 11132, 11434, 11804, 12125, 12477, 12823, 13173, 13509, 14445, 14652, 15316, 15652, 16052, 16413, 16773, 17117,
					17468, 17838, 18147, 18349, 18469, 18589, 18708, 18813, 19109, 19461, 19821, 20133, 20486, 20821, 21133, 21460, 21797, 22148, 22420,
					22764, 22892, 23028, 23204, 23396, 23588, 23773, 23924, 24035, 24141, 24461, 24813, 25067, 25293, 25613, 25788, 25901, 26157, 26404,
					26668, 26973, 27149, 27291, 27493, 27774, 27990, 28255, 28456, 28560, 28822, 29071, 29294, 29424, 29505, 29761, 29875, 30147, 30386,
					30621, 30946, 31154, 31267, 31476, 31724, 31947, 32264, 32435, 32548, 32797, 33003, 33171, 33323, 33451, 33618, 33779, 33995, 34167,
					34357, 34670, 35126, 35422, 35720, 35949, 36286, 36454, 36567, 36814, 37094, 37335, 37598, 37797, 37895, 38159, 38407, 38589, 38935,
					39086, 39223, 39471, 39696, 39942, 40062, 40159, 40440, 40624, 40816, 41038, 41279, 41591, 41799, 41912, 42153, 42416, 42621, 42894,
					43118, 43221, 43454, 43606, 43749, 44041, 44187, 44367, 44545, 44690, 44791, 44904, 45035, 45151, 45181, 47338, 47641, 47936, 49002,
					49241, 49962, 50297, 50504, 50625, 50744, 51057, 51416, 51786, 52145, 52513, 52817, 53171, 53504, 53800, 54138, 54441, 54786, 54969,
					55144, 55434, 55595, 55762, 55930, 56103, 56440, 56800, 57153, 57480, 57832, 58163, 58475, 58786, 59148, 59472, 59786, 60107, 60464,
					60761, 61040, 61151, 61257, 61364, 61718, 62085, 62445, 62794, 63116, 63461, 63793, 64085, 64446, 64799, 65155, 65478, 65730, 65930,
					66126, 66317, 66482, 66639, 67091, 67540, 67732, 67957, 68241, 68415, 68421, 68707, 69057, 69290, 69614, 69784, 69792, 70167, 70382,
					70626, 70930, 71152, 71160, 71504, 71766, 71912, 71920, 72120, 72362, 72371, 72788, 73038, 73278, 73567, 73819, 73828, 74189, 74423,
					74647, 74988, 75145, 75152, 75520, 75706, 75844, 76039, 76208, 76338, 76523, 76676, 76685, 76785, 77040, 77325, 77333, 77814, 78145,
					78410, 78600, 78962, 79070, 79116, 79484, 79728, 79928, 80245, 80418, 80527, 80859, 81096, 81313, 81644, 81754, 81815, 82177, 82403,
					82511, 82580, 82680, 83073, 83193, 83531, 83749, 83992, 84280, 84503, 84486, 84857, 85061, 85278, 85597, 85606, 85706, 86109, 86321,
					86533, 86688, 86844, 87051, 87419, 87600, 87790, 87959, 88066, 89138, 89795, 90411, 91111, 91751, 92438, 92864, 93162, 93171, 93766,
					94424, 95084, 95729, 96415, 97031, 97443, 97453, 97880, 98123, 98131, 98231, 98560, 99177, 99494, 99737, 99978, 100291, 100532, 100540,
					100896, 101114, 101376, 101662, 101671, 101920, 102186, 102426, 102654, 103021, 103031, 103131, 103681, 103953, 103959, 104449, 104717,
					105006, 105210, 105644, 105754, 105835, 106280, 106420, 106803, 107142, 107502, 107806, 108145, 108152, 108252, 108840, 109013, 109239,
					109245, 110433, 110693, 112076, 113384, 114628, 115938, 117346, 118659, 120040
				];
		}
		return [];
	}

	public static function getSteps(song:String = ''):Array<Int>
	{
		switch (song.toLowerCase())
		{
			case 'bopeebo':
				return [
					1, 4, 6, 10, 12, 16, 20, 22, 26, 28, 32, 37, 38, 42, 44, 48, 52, 54, 58, 60, 64, 67, 70, 74, 77, 80, 83, 86, 90, 93, 96, 99, 102, 106,
					109, 112, 115, 118, 122, 124, 128, 131, 134, 138, 141, 144, 147, 150, 154, 157, 160, 163, 166, 170, 173, 176, 179, 182, 186, 188, 190,
					192, 196, 198, 202, 205, 208, 211, 214, 218, 221, 224, 227, 230, 234, 237, 240, 243, 246, 250, 252, 256, 259, 262, 263, 265, 266, 268,
					269, 270, 272, 275, 276, 278, 279, 281, 282, 284, 285, 286, 288, 292, 294, 295, 297, 298, 300, 301, 302, 304, 307, 308, 310, 311, 313,
					314, 316, 318, 319, 320, 323, 326, 330, 333, 336, 339, 342, 346, 349, 352, 355, 358, 362, 365, 368, 371, 373, 378, 380, 382, 384, 387,
					390, 393, 396, 400, 403, 405, 410, 413, 416, 419, 422, 426, 429, 432, 434, 437, 442, 444, 446, 448, 451, 454, 458, 461, 464, 467, 469,
					474, 477, 480, 483, 485, 489, 492, 496, 499, 502, 506, 508
				];
			case 'fresh':
				return [
					0, 2, 4, 7, 9, 10, 12, 16, 18, 20, 23, 25, 26, 28, 32, 34, 36, 39, 42, 43, 44, 48, 50, 52, 55, 57, 58, 60, 62, 67, 70, 78, 86, 94, 102,
					110, 111, 118, 125, 128, 135, 142, 150, 158, 166, 176, 178, 180, 183, 185, 186, 188, 192, 196, 199, 200, 202, 206, 210, 214, 216, 218,
					222, 224, 226, 231, 232, 234, 238, 240, 242, 246, 248, 250, 254, 256, 258, 262, 264, 266, 270, 272, 274, 278, 280, 282, 286, 288, 290,
					294, 296, 298, 302, 304, 306, 310, 312, 314, 320, 326, 334, 342, 350, 358, 366, 367, 372, 378, 380, 384, 391, 399, 406, 414, 423, 430,
					431, 432, 434, 436, 439, 441, 442, 444, 448, 452, 455, 456, 458, 462, 464, 467, 471, 473, 474, 478, 480, 482, 486, 488, 490, 494, 496,
					498, 503, 504, 506, 510, 512, 514, 518, 520, 522, 526, 528, 530, 534, 536, 538, 542, 544, 546, 550, 552, 554, 558, 560, 562, 566, 568,
					570, 576, 580, 583, 585, 586, 588, 592, 594, 596, 599, 601, 602, 604, 608, 610, 612, 615, 618, 619, 620, 624, 626, 629, 631, 633, 634, 636
				];
			case 'dad-battle':
				return [
					3, 9, 11, 13, 15, 20, 25, 27, 29, 33, 38, 41, 44, 46, 51, 57, 59, 61, 65, 69, 73, 75, 77, 79, 85, 89, 91, 93, 97, 103, 107, 109, 111, 117,
					121, 123, 125, 129, 132, 134, 139, 141, 144, 149, 150, 154, 156, 160, 165, 166, 170, 172, 176, 178, 180, 184, 187, 189, 193, 197, 198,
					202, 204, 209, 213, 215, 218, 221, 225, 228, 230, 234, 236, 240, 244, 248, 253, 256, 262, 263, 267, 269, 273, 277, 279, 283, 285, 289,
					293, 294, 298, 300, 304, 306, 308, 311, 315, 317, 321, 324, 326, 330, 333, 337, 341, 343, 346, 348, 352, 357, 361, 365, 369, 372, 376,
					380, 382, 383, 396, 400, 409, 416, 423, 431, 440, 448, 457, 480, 495, 504, 512, 524, 528, 537, 544, 557, 567, 575, 580, 584, 588, 593,
					597, 600, 604, 608, 610, 612, 615, 617, 619, 621, 623, 624, 626, 628, 629, 630, 632, 633, 635, 636, 637, 639, 640, 644, 647, 650, 652,
					657, 661, 663, 667, 669, 673, 677, 679, 682, 684, 688, 691, 693, 698, 700, 704, 708, 711, 715, 717, 721, 725, 727, 730, 732, 736, 740,
					744, 748, 752, 753, 757, 761, 765, 769, 772, 774, 778, 780, 785, 789, 790, 795, 796, 800, 805, 806, 810, 812, 816, 820, 821, 826, 829,
					831, 833, 837, 839, 843, 845, 849, 852, 854, 858, 861, 864, 868, 870, 874, 876, 877, 879, 880, 884, 889, 893, 894, 896, 900, 904, 906,
					909, 911, 916, 920, 922, 924, 929, 934, 936, 939, 941, 943, 949, 953, 955, 957, 961, 965, 969, 971, 973, 975, 981, 984, 987, 988, 993,
					998, 1000, 1002, 1005, 1006, 1012, 1016, 1018, 1019, 1021, 1023, 1024, 1026, 1027, 1029, 1030
				];
			case 'spookeez':
				return [
					64, 68, 72, 77, 80, 84, 89, 93, 97, 101, 105, 109, 113, 117, 121, 124, 128, 132, 137, 141, 144, 148, 152, 156, 161, 165, 168, 172, 176,
					180, 185, 189, 192, 193, 194, 197, 198, 200, 202, 203, 205, 206, 207, 209, 211, 212, 215, 217, 218, 220, 222, 225, 226, 227, 229, 231,
					233, 235, 237, 238, 240, 241, 243, 245, 246, 247, 249, 252, 254, 256, 257, 258, 260, 262, 263, 265, 266, 267, 269, 270, 272, 273, 275,
					277, 278, 279, 281, 284, 286, 288, 289, 290, 292, 294, 295, 297, 298, 299, 301, 304, 305, 306, 308, 310, 312, 316, 318, 320, 322, 325,
					329, 333, 334, 337, 341, 342, 345, 352, 355, 357, 359, 361, 366, 367, 374, 376, 380, 382, 385, 386, 389, 392, 396, 398, 399, 400, 404,
					406, 409, 413, 415, 417, 420, 424, 428, 431, 432, 433, 436, 439, 441, 444, 446, 449, 450, 451, 453, 454, 456, 457, 459, 460, 461, 464,
					465, 466, 468, 470, 471, 473, 474, 476, 480, 481, 482, 485, 486, 488, 490, 491, 493, 494, 497, 498, 499, 502, 503, 504, 508, 510, 513,
					529, 530, 533, 534, 537, 538, 540, 541, 544, 546, 547, 549, 551, 553, 554, 557, 558, 559, 563, 564, 568, 571, 572, 573, 576, 581, 585,
					589, 591, 592, 595, 598, 602, 604, 607, 608, 612, 614, 618, 621, 623, 625, 629, 631, 634, 636, 639, 640, 645, 649, 652, 657, 659, 661,
					665, 669, 673, 677, 709, 712, 717, 721, 724, 729, 736, 740, 744, 748, 752, 756, 760, 768, 772, 776, 780, 784, 788, 792, 799, 804, 808,
					812, 816, 820, 824, 832, 834, 840, 844, 848, 853, 857, 864, 868, 873, 876, 880, 884, 888, 896, 900, 904, 908, 912, 916, 920, 928, 932,
					936, 941, 946, 951, 956, 961
				];
			case 'south':
				return [
					3, 67, 69, 71, 73, 75, 77, 79, 80, 83, 85, 87, 88, 91, 93, 95, 96, 99, 101, 103, 106, 107, 109, 112, 116, 120, 125, 128, 136, 141, 148,
					156, 160, 165, 169, 173, 181, 185, 189, 192, 200, 204, 211, 218, 224, 232, 236, 240, 244, 249, 252, 256, 264, 268, 277, 285, 289, 296,
					300, 308, 315, 320, 328, 333, 337, 344, 348, 352, 360, 368, 372, 376, 381, 384, 389, 397, 405, 413, 421, 428, 436, 444, 452, 460, 468,
					475, 483, 491, 496, 500, 504, 508, 513, 517, 525, 533, 540, 548, 556, 564, 572, 580, 588, 596, 604, 612, 620, 628, 636, 641, 648, 653,
					661, 668, 672, 680, 684, 693, 699, 704, 712, 717, 724, 731, 736, 743, 752, 756, 761, 765, 769, 777, 781, 789, 797, 801, 809, 813, 821,
					827, 832, 838, 841, 845, 849, 856, 861, 865, 872, 880, 884, 888, 893, 931, 945, 956
				];
			case 'pico':
				return [
					20, 24, 30, 34, 37, 40, 44, 50, 54, 58, 61, 64, 71, 74, 80, 84, 90, 94, 99, 101, 105, 111, 116, 122, 125, 131, 136, 142, 146, 152, 156,
					159, 162, 166, 172, 174, 175, 177, 178, 180, 180, 181, 183, 186, 192, 196, 202, 206, 212, 216, 223, 227, 233, 237, 243, 247, 253, 257,
					263, 267, 274, 278, 284, 287, 294, 298, 302, 304, 307, 314, 318, 324, 328, 334, 336, 337, 339, 340, 342, 343, 344, 347, 355, 359, 364,
					369, 374, 379, 382, 385, 389, 395, 399, 402, 405, 409, 415, 417, 418, 420, 422, 423, 424, 426, 429, 433, 435, 439, 442, 445, 449, 453,
					455, 458, 463, 466, 470, 473, 476, 480, 484, 486, 490, 494, 497, 500, 504, 507, 510, 512
				];
			case 'philly':
				return [
					33, 39, 44, 48, 53, 61, 64, 69, 76, 80, 85, 91, 92, 96, 104, 112, 118, 124, 128, 134, 140, 143, 148, 152, 157, 160, 166, 176, 180, 185,
					187, 192, 196, 197, 203, 204, 208, 212, 213, 217, 220, 222, 223, 225, 229, 231, 235, 237, 241, 245, 247, 251, 252, 255, 256, 261, 263,
					267, 271, 272, 276, 278, 282, 287, 288, 293, 295, 299, 301, 304, 305, 309, 311, 315, 317, 320, 321, 325, 326, 330, 332, 336, 340, 342,
					346, 348, 351, 353, 357, 358, 362, 364, 368, 372, 374, 379, 380, 382, 385, 389, 391, 395, 396, 397, 399, 402, 405, 407, 408, 410, 411,
					412, 414, 415, 420, 423, 425, 429, 433, 437, 439, 443, 445, 448, 453, 458, 461, 464, 468, 481, 482, 485, 489, 491, 494, 497, 499, 501,
					506, 508, 512, 514, 517, 522, 524, 528, 532, 537, 541, 545, 550, 556, 561, 566, 573, 577, 582, 588, 593, 598, 604, 608, 613, 620, 625,
					630, 637, 641, 646, 652, 657, 661, 665, 668, 672, 675, 677, 679, 681, 688, 694, 695, 704, 711, 720, 727, 736, 742, 752, 758, 768, 774,
					784, 790, 800, 806, 816, 822, 832, 837, 847, 853, 864, 869, 879, 886, 895, 902, 912, 918, 928, 933, 940, 945, 949, 955, 957, 961, 965,
					971, 973, 977, 980, 987, 989, 993, 997, 1003, 1005, 1009, 1013, 1019, 1021, 1025, 1029, 1035, 1037, 1041, 1045, 1049, 1052, 1054, 1057,
					1062, 1069, 1089, 1095, 1101
				];
			case 'blammed':
				return [
					127, 135, 139, 147, 152, 159, 166, 171, 179, 185, 192, 199, 204, 212, 216, 223, 229, 235, 244, 248, 256, 268, 275, 287, 293, 299, 307,
					320, 328, 332, 339, 351, 358, 363, 372, 383, 388, 395, 400, 404, 406, 410, 412, 416, 420, 421, 426, 429, 433, 436, 439, 442, 444, 448,
					449, 452, 454, 457, 461, 465, 469, 471, 474, 477, 481, 482, 485, 487, 492, 496, 503, 512, 525, 532, 544, 550, 555, 564, 568, 576, 583,
					588, 595, 607, 613, 619, 628, 633, 640, 652, 659, 672, 678, 684, 692, 703, 716, 723, 736, 742, 748, 756, 767, 775, 779, 781, 785, 788,
					792, 795, 797, 801, 804, 806, 810, 813, 817, 820, 822, 826, 829, 831, 833, 836, 837, 840, 844, 848, 853, 859, 861, 864, 866, 868, 869,
					873, 876, 880, 885, 888, 891, 893, 896, 902, 911, 918, 928, 934, 943, 949, 959, 966, 972, 976, 979, 981, 985, 989, 992, 997, 1003, 1008,
					1015, 1024, 1049, 1051, 1053, 1056, 1081, 1083, 1087, 1112, 1114, 1116, 1119, 1143, 1145, 1147, 1149, 1151
				];
			case 'satin-panties':
				return [
					1, 11, 12, 13, 14, 15, 25, 26, 27, 28, 30, 31, 32, 36, 39, 42, 45, 48, 53, 55, 58, 61, 64, 68, 70, 74, 76, 80, 84, 86, 88, 89, 90, 91, 92,
					93, 95, 96, 97, 100, 102, 106, 108, 113, 116, 117, 118, 119, 122, 122, 124, 126, 128, 132, 134, 138, 140, 144, 148, 150, 152, 153, 154,
					156, 157, 158, 159, 160, 164, 166, 170, 172, 176, 180, 182, 186, 188, 192, 196, 198, 202, 204, 208, 213, 214, 216, 217, 218, 219, 220,
					221, 222, 224, 225, 228, 230, 234, 236, 240, 243, 244, 246, 247, 249, 250, 252, 256, 260, 262, 266, 268, 272, 274, 276, 278, 280, 281,
					282, 284, 284, 285, 287, 288, 290, 292, 294, 298, 300, 304, 307, 310, 314, 316, 320, 324, 326, 330, 332, 336, 340, 342, 342, 344, 345,
					346, 347, 348, 349, 351, 352, 354, 356, 358, 362, 364, 368, 373, 375, 378, 380, 384, 388, 390, 394, 396, 400, 403, 404, 406, 408, 409,
					410, 412, 413, 414, 416, 416, 420, 422, 426, 428, 432, 436, 438, 442, 444, 448, 452, 454, 458, 460, 464, 468, 470, 474, 476, 477, 479,
					480, 484, 486, 490, 492, 496, 500, 502, 506, 508, 512, 516, 518, 522, 524, 528, 531, 533, 535, 536, 537, 538, 540, 541, 542, 544, 544,
					548, 550, 554, 556, 560, 563, 564, 566, 567, 570, 571, 573, 576, 580, 582, 586, 588, 592, 595, 596, 598, 601, 601, 602, 604, 605, 606,
					608, 609, 612, 614, 616, 618, 620, 622, 624, 626, 628, 630, 632, 634, 636, 638, 640
				];
			case 'high':
				return [
					4, 11, 12, 15, 17, 20, 21, 27, 28, 29, 30, 32, 36, 39, 42, 43, 45, 48, 53, 55, 59, 61, 64, 69, 71, 74, 77, 80, 85, 87, 90, 92, 96, 100,
					102, 106, 108, 110, 113, 116, 119, 122, 125, 128, 131, 132, 134, 138, 141, 144, 148, 150, 152, 154, 156, 158, 160, 164, 166, 170, 172,
					177, 181, 183, 186, 188, 192, 196, 198, 202, 204, 208, 212, 214, 218, 220, 222, 224, 228, 230, 234, 236, 241, 244, 247, 250, 252, 256,
					260, 262, 266, 268, 272, 274, 277, 279, 281, 282, 284, 286, 288, 292, 294, 298, 301, 304, 305, 308, 310, 314, 316, 320, 324, 329, 331,
					335, 340, 344, 348, 352, 356, 358, 362, 364, 368, 372, 375, 378, 380, 384, 388, 390, 394, 396, 400, 404, 408, 412, 416, 420, 425, 428,
					433, 436, 440, 445, 448, 453, 456, 460, 464, 468, 472, 476, 479, 484, 488, 492, 495, 500, 504, 508, 511, 512, 516, 520, 524, 527, 531,
					536, 538, 540, 543, 544, 548, 550, 555, 557, 560, 564, 566, 570, 572, 576, 580, 582, 586, 588, 592, 596, 600, 604, 608, 612, 614, 618,
					620, 624, 628, 630, 634, 636, 640, 644, 646, 650, 652, 656, 659, 663, 668, 672, 676, 683, 688, 694, 697, 699, 704, 706, 707, 708, 709,
					712, 714, 716, 718, 720, 722, 725, 726, 727, 728, 731, 733, 735, 737, 748, 752, 756, 758, 762, 764, 766, 768, 770, 772, 773, 775, 777,
					779, 781, 783, 784, 787, 788, 789, 791, 792, 794, 796, 798, 799, 801
				];
			case 'milf':
				return [
					32, 36, 40, 44, 48, 52, 57, 61, 65, 69, 73, 77, 81, 85, 89, 92, 95, 96, 101, 105, 109, 113, 117, 121, 124, 127, 129, 132, 137, 141, 145,
					149, 153, 157, 161, 172, 176, 184, 187, 192, 204, 207, 215, 224, 228, 233, 237, 241, 245, 249, 253, 257, 261, 265, 268, 272, 275, 277,
					280, 282, 284, 288, 292, 296, 300, 303, 306, 308, 312, 316, 319, 323, 324, 329, 332, 335, 339, 340, 342, 345, 348, 351, 353, 356, 360,
					364, 366, 371, 373, 374, 377, 380, 383, 387, 389, 390, 393, 396, 398, 400, 401, 405, 408, 413, 416, 420, 424, 427, 430, 434, 436, 437,
					441, 444, 447, 450, 452, 454, 457, 460, 463, 467, 469, 470, 473, 476, 479, 480, 485, 488, 491, 494, 499, 501, 502, 505, 508, 510, 515,
					517, 518, 521, 524, 526, 527, 529, 532, 536, 538, 541, 543, 545, 548, 551, 556, 559, 560, 568, 571, 575, 588, 590, 600, 608, 613, 617,
					622, 625, 629, 633, 637, 641, 645, 649, 652, 804, 812, 820, 828, 836, 844, 852, 859, 868, 876, 885, 893, 900, 909, 912, 915, 917, 921,
					923, 924, 926, 927, 932, 937, 941, 944, 947, 949, 953, 956, 959, 963, 964, 966, 969, 972, 975, 979, 980, 982, 986, 989, 991, 996, 999,
					1000, 1002, 1006, 1008, 1012, 1014, 1017, 1020, 1023, 1027, 1028, 1030, 1033, 1037, 1038, 1040, 1041, 1044, 1048, 1050, 1052, 1055, 1057,
					1060, 1064, 1067, 1071, 1077, 1084, 1092, 1100, 1108, 1116, 1121, 1125, 1132, 1140, 1148, 1156, 1164, 1168, 1172, 1176, 1178, 1181, 1183,
					1185, 1189, 1193, 1197, 1199, 1207, 1209, 1212, 1215, 1228, 1230, 1240, 1248, 1253, 1257, 1261, 1264, 1268, 1269, 1271, 1274, 1278, 1280,
					1284, 1285, 1286, 1289, 1292, 1295, 1297, 1299, 1301, 1305, 1307, 1309, 1311, 1313, 1325, 1328, 1336, 1339, 1343, 1356, 1359, 1367, 1375,
					1389, 1392, 1402, 1405, 1408, 1420, 1422, 1428, 1433, 1436, 1440
				];
			case 'cocoa':
				return [
					1, 4, 7, 16, 20, 23, 26, 32, 36, 39, 42, 48, 52, 55, 58, 64, 68, 73, 77, 80, 84, 86, 92, 96, 100, 102, 106, 110, 112, 115, 118, 124, 128,
					132, 135, 138, 142, 144, 148, 151, 154, 159, 164, 166, 170, 173, 176, 180, 180, 183, 186, 189, 192, 196, 198, 203, 206, 208, 212, 215,
					218, 224, 228, 231, 234, 237, 240, 244, 247, 250, 256, 260, 262, 262, 266, 269, 272, 275, 278, 282, 285, 288, 292, 295, 298, 301, 304,
					308, 311, 314, 317, 320, 324, 326, 330, 333, 336, 340, 342, 343, 345, 346, 348, 352, 356, 359, 362, 365, 368, 372, 374, 378, 380, 384,
					388, 390, 394, 397, 400, 404, 407, 410, 413, 416, 420, 423, 426, 429, 432, 436, 439, 441, 442, 444, 446, 448, 452, 455, 458, 461, 464,
					468, 471, 474, 477, 480, 483, 487, 490, 493, 496, 499, 502, 506, 508, 512, 516, 519, 522, 525, 528, 532, 535, 538, 541, 544, 548, 551,
					554, 558, 560, 564, 567, 570, 573, 576, 580, 582, 586, 589, 592, 596, 598, 602, 605, 608, 612, 614, 618, 621, 624, 628, 630, 633, 636,
					639, 643, 646, 650, 653, 656, 660, 663, 666, 669, 672, 676, 678, 682, 684, 687, 692, 694, 698, 700, 704
				];
			case 'eggnog':
				return [
					35, 39, 43, 46, 48, 52, 54, 56, 59, 62, 65, 67, 70, 72, 76, 78, 80, 83, 86, 88, 91, 94, 96, 99, 102, 104, 107, 110, 112, 115, 118, 120,
					123, 126, 128, 131, 134, 136, 139, 142, 144, 147, 150, 152, 156, 157, 158, 159, 164, 166, 169, 172, 176, 182, 188, 192, 197, 204, 206,
					210, 215, 220, 225, 230, 236, 240, 246, 252, 256, 260, 264, 268, 271, 276, 280, 283, 288, 291, 296, 300, 304, 309, 312, 316, 320, 324,
					328, 332, 335, 340, 343, 347, 352, 355, 360, 363, 368, 372, 376, 380, 384, 388, 392, 396, 400, 404, 408, 412, 416, 420, 424, 428, 432,
					434, 436, 439, 442, 443, 446, 449, 451, 453, 455, 458, 459, 460, 463, 465, 467, 469, 471, 474, 475, 477, 479, 481, 485, 487, 490, 494,
					496, 499, 502, 504, 507, 510, 512, 516, 519, 521, 524, 526, 528, 530, 534, 536, 539, 541, 545, 547, 550, 552, 555, 558, 560, 563, 566,
					568, 571, 574, 576, 579, 582, 584, 587, 590, 592, 595, 598, 600, 604, 605, 606, 608, 612, 616, 620, 624, 630, 636, 640, 645, 649, 652,
					654, 660, 668, 672, 676, 680, 684, 686, 688, 693, 700, 704, 709, 712, 716, 720, 725, 732, 736, 740, 744, 748, 752, 756, 759, 763, 767,
					771, 775, 779, 783, 787, 791, 796, 799, 803, 808, 811, 815, 819, 823, 827, 831, 836, 840, 844, 848, 852, 856, 860, 864, 868, 872, 874,
					876, 880, 884, 888, 892, 896, 898, 900, 904, 906, 909, 912, 914, 916, 919, 922, 925, 929
				];
			case 'senpai':
				return [
					2, 5, 8, 12, 16, 20, 24, 28, 31, 35, 39, 44, 47, 51, 56, 56, 60, 60, 64, 68, 72, 74, 78, 81, 85, 89, 91, 95, 100, 104, 106, 110, 114, 118,
					122, 124, 128, 131, 136, 140, 144, 150, 152, 156, 158, 159, 163, 166, 172, 176, 182, 188, 190, 192, 196, 198, 201, 204, 206, 208, 213,
					220, 223, 228, 228, 230, 239, 245, 251, 256, 260, 264, 268, 272, 276, 280, 284, 288, 292, 296, 300, 303, 307, 311, 315, 319, 324, 326,
					331, 335, 339, 343, 347, 351, 355, 359, 363, 367, 371, 375, 380, 382, 384, 388, 391, 395, 398, 404, 406, 410, 412, 416, 420, 422, 426,
					428, 430, 434, 436, 438, 442, 444, 447, 452, 454, 458, 460, 462, 466, 468, 470, 474, 476, 478, 480, 484, 486, 490, 492, 494, 497, 500,
					501, 503, 505, 508, 510, 512, 516, 520, 524, 528, 532, 536, 540, 544, 547, 551, 555, 559, 563, 567, 571, 576, 580, 584, 586, 590, 594,
					597, 601, 604, 607, 611, 616, 618, 622, 625, 629, 633, 636, 639, 644, 648, 652, 653, 656, 660, 662, 666, 668, 672, 676, 678, 682, 684,
					686, 690, 692, 694, 697, 700, 703, 708, 710, 714, 716, 718, 722, 724, 726, 730, 732, 736, 740, 742, 746, 748, 750, 753, 756, 758, 760,
					762, 764, 767, 771, 774, 778, 780, 782, 786, 788, 790, 792, 794, 796, 800, 804, 806, 810, 812, 814, 818, 820, 822, 824, 826, 828, 832,
					836, 838, 842, 844, 846, 850, 852, 854, 856, 858, 860, 864, 868, 870, 874, 876, 878, 882, 884, 886, 888, 890, 892, 896, 900
				];
			case 'roses':
				return [
					6, 9, 11, 15, 20, 23, 26, 28, 29, 31, 34, 38, 41, 44, 49, 52, 55, 60, 63, 66, 68, 71, 73, 74, 78, 82, 85, 88, 90, 92, 93, 96, 98, 99, 101,
					103, 104, 106, 108, 109, 112, 114, 116, 117, 119, 120, 122, 123, 125, 127, 128, 133, 134, 135, 138, 139, 141, 146, 147, 149, 151, 153,
					157, 158, 160, 162, 164, 165, 168, 171, 174, 175, 177, 183, 185, 188, 192, 198, 200, 203, 205, 206, 208, 211, 215, 218, 221, 227, 230,
					232, 237, 242, 245, 248, 250, 251, 252, 255, 260, 262, 266, 267, 268, 271, 272, 274, 277, 278, 279, 282, 283, 285, 288, 289, 291, 294,
					295, 296, 299, 301, 302, 304, 306, 307, 309, 311, 312, 315, 317, 318, 321, 322, 324, 326, 328, 329, 332, 334, 335, 337, 339, 340, 343,
					344, 346, 348, 350, 352, 354, 360, 362, 365, 369, 372, 375, 378, 381, 382, 384, 387, 391, 394, 394, 398, 403, 406, 409, 413, 416, 420,
					422, 425, 427, 428, 432, 436, 439, 442, 444, 445, 447, 449, 453, 458, 461, 463, 467, 469, 471, 472, 476, 480, 483, 486, 492, 494, 497,
					501, 505, 508, 511, 514, 515, 517, 520, 524, 528, 531, 534, 537, 538, 540, 542, 544, 546, 548, 553, 555, 556, 557, 559, 560, 562, 563,
					565, 566, 568, 569, 570, 575, 576, 578, 579, 580, 582, 584, 585, 587, 588, 589, 591, 592, 598, 599, 601, 602, 604, 605, 606, 608, 609,
					611, 612, 613, 614, 620, 621, 623, 625, 628, 631, 633, 635, 637, 639, 640, 644, 648, 650, 651, 655, 656, 659, 660, 664, 666, 669, 671,
					673, 677, 680, 682, 684, 688, 691, 694, 696, 699, 702, 708, 709, 710, 712, 713, 715, 716, 717, 719, 722, 723, 724, 729, 732, 735, 735,
					737, 741, 745, 748, 751, 758, 761, 763, 768, 771, 774, 777, 779, 781, 784, 787, 791, 793, 796, 802, 804, 808, 813, 817, 819, 824, 825,
					827, 829, 833, 834, 837, 839, 841, 844, 847, 848, 849, 852, 853, 855, 858, 859, 860, 863, 865, 866, 869, 870, 872, 874, 876, 879, 883,
					885, 889, 891, 895, 897, 901, 904, 907, 910, 913, 914, 915, 918, 922, 926, 928, 934, 937, 940, 944, 947, 950, 953, 956, 957, 959, 960,
					963, 968, 971, 974, 975, 976
				];
			case 'thorns':
				return [
					3, 7, 12, 20, 26, 28, 32, 39, 44, 51, 53, 58, 65, 71, 77, 85, 89, 92, 96, 103, 109, 116, 121, 123, 128, 133, 137, 141, 145, 149, 153, 157,
					161, 165, 169, 173, 177, 181, 185, 190, 193, 197, 201, 205, 209, 214, 217, 221, 225, 229, 233, 237, 241, 245, 249, 253, 257, 261, 269,
					276, 285, 292, 300, 308, 316, 325, 332, 340, 348, 356, 363, 368, 372, 376, 381, 383, 385, 389, 393, 397, 401, 405, 409, 413, 417, 421,
					425, 429, 433, 438, 441, 445, 449, 453, 457, 461, 465, 469, 473, 478, 481, 485, 489, 493, 497, 501, 505, 509, 513, 517, 524, 529, 533,
					541, 545, 549, 555, 561, 566, 571, 574, 577, 581, 585, 589, 593, 597, 601, 605, 609, 613, 617, 621, 625, 629, 633, 637, 641, 645, 653,
					661, 669, 677, 684, 692, 700, 705, 709, 716, 725, 732, 741, 748, 752, 756, 760, 763, 765, 766, 767, 769, 773, 777, 782, 785, 789, 793,
					798, 801, 805, 809, 813, 817, 821, 825, 829, 833, 837, 841, 845, 849, 853, 857, 861, 865, 869, 873, 877, 881, 885, 889, 893, 897, 899,
					901, 904, 909, 913, 916, 918, 920, 925, 929, 933, 936, 941, 945, 949, 953, 957, 961, 965, 969, 973, 977, 981, 985, 989, 993, 997, 1001,
					1005, 1009, 1013, 1016, 1021, 1024, 1029, 1033, 1037, 1045, 1053, 1058, 1061, 1068, 1070, 1077, 1084, 1089, 1093, 1101, 1107, 1109, 1116,
					1122, 1125, 1130, 1133, 1137, 1141, 1147, 1149, 1153, 1157, 1163, 1172, 1177, 1180, 1185, 1191, 1197, 1204, 1209, 1211, 1213, 1217, 1223,
					1229, 1236, 1241, 1244, 1248, 1254, 1260, 1268, 1274, 1276, 1280
				];
		}
		return [0];
	}
}
