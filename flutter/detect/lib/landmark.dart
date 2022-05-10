//랜드마크 변수
//latitude 위도
//longitude 경도
List<Map> landmark = [
  {'name': 'north', 'latitude': 35.8919, 'longitude': 128.609952},
  {'name': 'front', 'latitude': 35.88517, 'longitude': 128.61447},
  {'name': 'facepark', 'latitude': 0, 'longitude': 0},
  {'name': 'onebluedam', 'latitude': 0, 'longitude': 0},
  {'name': 'top', 'latitude': 0, 'longitude': 0},
];

var nameList = ['북문', '정문', '상면', '일청담', '3층 석탑'];

var imageList = [
  'image/north.PNG',
  'image/front.PNG',
  'image/fackpark.jpg',
  'image/onebluedam.png',
  'image/top.png'
];

var description = ['인증 미완료', '인증 미완료', '인증 미완료', '인증 미완료', '인증 미완료'];

void changeDescription(int index) {
  description[index] = '인증 완료';
}
