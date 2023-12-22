# 🥤쥬스자판기
각 쥬스를 만들면 과일재고가 수정되고, 과일재고를 추가하고 뺄수 있도록 구현한 프로젝트입니다.


## 목차

1. [팀원](#1-팀원)
2. [클래스다이어그램](#2-클래스-다이어그램)
3. [타임라인](#3-타임라인)
4. [실행 화면(기능 설명)](#4-실행화면기능-설명)
5. [트러블 슈팅](#5-트러블-슈팅)
6. [참고 링크](#6-참고-링크)
7. [팀 회고](#7-팀-회고)

<br>

## 1. 팀원

| [mireu](https://github.com/mireu930)  | [misung](https://github.com/crisine) |
| :--------: | :--------: |
|<img src=https://github.com/mireu79/ios-rock-paper-scissors/assets/125941932/b4a69222-b338-4a7f-984c-be5bd78dc1d8 height="150"/> |<img src=https://github.com/mireu930/ios-juice-maker/assets/148876644/4fe01dba-5a3a-4bce-92e1-7d5cc6a8f9d6 height="150"/> | 

<br>

## 2. 클래스 다이어그램

![클래스다이어그램](https://github.com/mireu930/ios-juice-maker/assets/148876644/348c83ab-72a8-4dbd-8050-eb5b3cb5b6be)



<br>

## 3. 타임라인
|날짜|내용|
|------|---|
|23.12.4|프로젝트 흐름에 대한 파악 및 공식문서 공부 <br> 쥬스와 과일에 대한 enum타입 구현|
|23.12.5| FruitStore와 JuiceMaker에 대한 타입 구현 <br> FruitStore타입에 재고에 소모하려는 수보다 적은지에 대한 유효성 검사에 대한 함수 구현 및 재고가 소모되는 함수 구현, `STEP1 PR작성` |
|23.12.6|`STEP1` 리팩토링 - Test 케이스 gitignore, <br> 각각 파일에 맞는 파라미터 지정(FruitStore -> fruit...) |
|23.12.7|재고수정버튼 누르면 재고수정화면으로 넘어가도록 구현, <br> 쥬스주문을 하면 각각 과일의 재고가 깎이는 것과 알럿창이 나오도록 구현, <br> 메인화면과 재고수정화면 재고가 같도록 싱글톤사용하여 구현, <br>`STEP2 PR 작성` |
|23.12.8|`STEP2` 리팩토링 - Alert 객체를 생성하여 타입한곳에서 AlertController 를 만들어주는 기능 추가|
|23.12.12|재고수정화면에서 stepper구현하여 재고수정되도록 구현, <br> 오토레이아웃 제약 및 화면전환방식 모달로 수정|
|23.12.13| `STEP3 PR작성`|
|23.12.15|`STEP3` 리팩토링 - IBAction, IBOutlet 접근제어, <br> StoryBoard 상의 identifier를 as 캐스팅으로 화면을 찾아가도록 변경, UIViewController Extension 그룹을 생성하여 String 타입 ID를 반환하는 계산 속성 생성, <br> Stepper를 누를 시 Fruit Model값을 바로 변경하지 않고, FruitStore의 updateFruitStock()을 통하여 값을 변경하도록 수정|
|23.12.18|델리게이션패턴 적용 <br> (프로토콜을 채택하여 Delegation이 할일을 다른 객체에 위임) |
|23.12.19|delegate프로퍼티에 weak키워드 사용하여 순환참조 방지, <br> safe indexing에 대해 알아보기(배열요소들이 없다면 index out of range 런타임에러가 나는데 그래서 safe indexing이라고 배열에 안전하게 조회하기 위해 startIndex, endIndex 등의 방법을 사용하여 안전하게 배열을 조회) |
|23.12.20| 라이프사이클 메서드를 이용한 UI업데이트가 아닌 delegate메서드를 통해 UI업데이트되도록 수정, stepper가 눌리면 재고가 수정될수 있도록 수정 |

 
<br>

## 4. 실행화면(기능 설명)


| 주문성공  | 재고부족 재고수정 화면 이동  |
| :--------: | :--------: | 
|![](https://hackmd.io/_uploads/ryJL5jMxa.gif)|![](https://hackmd.io/_uploads/H1aK5ifgp.gif)|


|재고수정 후 닫기버튼 클릭|
| :--------: |
|![](https://hackmd.io/_uploads/BJZgoiMl6.gif)|

  

<br>

## 5. 트러블 슈팅
#### 1️⃣ 쥬스를 주문하는 과정에서 딸바/망키쥬스의 경우 복합적인 재료가 소모되는데, 초기 로직에서는 다음과 같은 상황에서 문제가 발생하였습니다. 그리고 로직의 진행 순서를 변경하여 이를 해결할 수 있었습니다.

> 초기 로직 : 딸기 재고 체크 -> 딸기 재고 없음 -> 바나나 재고 체크 -> 바나나 재고 소모 -> 모든 재료 정상 소모했는지? -> **에러 반환**
```swift
func orderJuice(juice: Juice) throws {        
    // 선행적으로 재료들의 수량을 체크하지 않아, 쥬스재료의 일부 재고가 부족함에도 충분한 재고쪽은 소모가 발생
    for (fruitName, quantity) in juice.recipe {
        try fruitStore.consumeFruit(fruit: fruitName, num: quantity)
    }
}
```
> 예시 상황 : 딸기 재고가 0개, 바나나가 9개 있을 때 딸바쥬스 주문 (딸기 10개, 바나나 1개 소모) -> 
딸기 재고가 없음에도 불구하고 바나나를 1개 소모해버림 
---
> 변경 로직 : 레시피 내 모든 재료 **재고 선행 체크** -> 실패 시 **에러 반환**, 성공 시 -> 재료 소모 -> 정상 종료
```swift
private func checkJuiceIngredients(juice: Juice) throws {
    for (fruitName, quantity) in juice.recipe {
        try fruitStore.checkStock(fruit: fruitName, num: quantity)
    }
}

func orderJuice(juice: Juice) throws {
    try checkJuiceIngredients(juice: juice) // 재고 선행 체크
    // 나머지 진행
}
```
 
#### 2️⃣ 소모하려는 과일갯수가 기존재고의 과일갯수를 넘어가면 과일이 부족하게 나오게하는 재고의 갯수에 대한 유효성 검사를 진행하는 메서드에서 유닛테스트를 진행했는데 max값을 넘어버리는 값이 나오는 오버플로우가 나는 연산이 되었는데, 쥬스가 만들어짐에 따라 과일재고보다 기존재고의 갯수의 이상으로 연산을 수정해줬습니다.
```swift
    //수정전
    private func checkStock(juice: Juice) throws {
        for (fruitName, numberOfFruits) in juice.recipe {
            guard let stock = fruitStock[fruitName] else { throw JuiceMakerError.outOfStock}
            guard stock - numberOfFruits > 0 else { throw JuiceMakerError.outOfStock}
        }

    //수정후
    private func checkStock(juice: Juice) throws {
        for (fruitName, numberOfFruits) in juice.recipe {
            guard let stock = fruitStock[fruitName], stock >= numberOfFruits else { throw JuiceMakerError.outOfStock }
        }
```
#### 3️⃣ 쥬스를 주문하는 화면의 경우 다음과 같은 함수를 통해 각 과일별 재고 Label을 수정할 수 있도록 해 주었습니다. 다만 재고수정화면에 바뀐 재고가 메인화면에서 반영되지 않았습니다.
```swift
private func updateFruitStockLabel() {
    let stock = fruitStore.fruitStock.compactMapValues { String($0) }

    strawberryLabel.text = stock[.strawberry]
    // 타 Label도 같은 방법으로 수정...
}
```
이제 여기서 해결해야 할 문제는 다음과 같았습니다.
1. 화면이 처음 로드되었을 때, 초기 재고를 보여줄 수 있어야 한다.
2. 재고 수정 후 쥬스 주문 화면으로 돌아왔을 때, 재고 화면에서 수정한 값을 즉시 Label들에 갱신해 줄 수 있어야 한다.

저희는 각각의 문제를 `ViewController` 의 `viewDidLoad`, `viewWillAppear` 를 오버라이딩 하여 해결하였습니다.

#### JuiceOrderViewController
```swift
override func viewDidLoad() {
    super.viewDidLoad()
    updateFruitStockLabel()
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateFruitStockLabel()
}
```
- `viewDidLoad` 를 통해 화면이 로드되는 즉시 과일 재고별 Label을 초기화하도록 설정
- `viewWillAppear` 를 통해 다른 `View` 에서 해당 메인 `View` 로 넘어오게 되면, 다시금 과일별 재고 Label을 갱신하도록 하였습니다. 

#### 4️⃣ 델리게이션 패턴을 적용했을때 UI업데이트를 라이프사이클에서 하는게 아닌 델리게이트에서 적용할때 델리게이트 메서드에 라이프사이클 매서드를 개발자가 임의로 호출하는것이 아닌 메인화면을 띄우는 메서드를 delegate 매서드 구현부에서 호출되도록 수정해줬습니다.
```swift
//수정전
extension JuiceOrderViewController: Delegate {
    func fruitStockDidChange(fruitStock: [Fruit : UInt]) {
        //...
    }
    override func viewWillAppear(_ animated: Bool) {
        //...
    }
    
//수정후
extension JuiceOrderViewController: ManageStockViewControllerDelegate {
    func fruitStockDidChange(fruitStock: [Fruit : UInt]) {
       //...
        }
        updateFruitStockLabel()
    }

```

#### 5️⃣ 배열에 요소가 없게되면 런타임에러가 발생하는데 이를 방지하기위 safe indexing으로 안전하게 배열을 조회하기 위해 .first나 .last를 이용해 배열에 요소가 없으면 nil로 반환할수 있게 에러를 방지한다.
```swift
//수정전
 guard let juiceName = sender.titleLabel?.text?.components(separatedBy: " ")[0] else {
           //...
            return
        }

//수정후
 guard let juiceName = sender.titleLabel?.text?.components(separatedBy: " ").first else {
           //...
            return
        }
```

<br>

## 6. 참고 링크
[📖 공식문서 Naming](https://www.swift.org/documentation/api-design-guidelines/)<br>
[📖 공식문서 Initialization](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/initialization/)<br>
[📖 공식문서 Access Control](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/)<br>
[📖 공식문서 Nested Types](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/nestedtypes/)<br>
[📖 공식문서 Type Casting](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/typecasting/)<br>
[📖 공식문서 Error Handling](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/errorhandling/)<br>
[📖 공식문서 UIModalPresentationStyle](https://developer.apple.com/documentation/uikit/uimodalpresentationstyle)<br>


<br>

## 7. 팀 회고
- 😄우리팀이 잘한 점 <br>
서로 의견을 존중해주며 짝프로그래밍을 잘 이행하였다.

- 😅우리팀이 개선할 점 <br>
깃헙을 좀 더 잘다룰수 있도록 학습해야겠다..



