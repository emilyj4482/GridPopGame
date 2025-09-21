# GridPopGame (고양이 퍼즐 게임)
같은 색깔의 고양이 퍼즐을 터뜨리는 게임입니다.
- `SpriteKit`으로 구현
- [개발과정을 담은 포스팅 시리즈](https://velog.io/@emilyj4482/series/GridPopGame)
- [시연 영상](https://youtube.com/shorts/jr8QYiAX6oY?feature=share)

안녕하세요, Emily입니다. 이 게임은 제가 `SpriteKit`을 독학하면서 처음으로 만든 프로젝트입니다. `SpriteKit`을 독학하게 된 계기는 인턴 근무를 앞두고 업무 요구사항에 맞는 역량을 갖추기 위함이었습니다.
<br>이 프로젝트는 하나의 게임 화면 단위인 씬(`SKScene`)과 그 안에 들어가는 컴포넌트 단위인 노드(`SKNode`)에 대해 이해하고, `UIView`와의 차이를 실감하는 기회가 되었습니다. 특히, `UIKit`에서 적용하는 오토레이아웃과 `SpriteKit`에서의 노드 배치 원칙은 많이 달랐습니다. 제가 `velog`에 올린 포스팅 시리즈를 보시면 더 자세한 설명을 보실 수 있습니다.

## 목차
- [주요 구현내용](#주요-구현내용)
- [트러블슈팅](#트러블슈팅)

<img src="https://github.com/user-attachments/assets/efba7a83-5e6f-4a99-aff6-f15452f941b7" width=400>

## 주요 구현내용

### 📌 SKSpriteNode로 이미지 추가
`Assets`에 추가한 이미지 파일명을 `SKSpriteNode(imageNamed: )`에 넣어 이미지 노드를 추가하였습니다. 노드를 씬에 추가할 때는 `addChild`를 해줍니다.
```swift
class GameScene: SKScene {
    private let backgroundImage = SKSpriteNode(imageNamed: "background")

    override func didMove(to: view: SKView) {
        self.size = view.bounds.size

        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.zPosition = -1
        backgroundImage.size = size

        addChild(backgroundImage)
    }
}
```

### 📌 8x8 격자로 고양이 퍼즐 배치
고양이 이미지 노드는 전역변수로 선언하지 않고 메소드 내에서 반복적으로 생성하며 8x8 그리드 형태로 포지셔닝을 하였습니다. 커스텀 노드를 정의하여 행/열 좌표값을 갖게 하고 이미지 크기를 반영한 `position`을 계산하였습니다.
```swift
class Item: SKSpriteNode {
    var column: Int
    var row: Int

    // ... //
}
```
```swift
func createItem(column: Int, row: Int) -> Item {
    let item = Item(column: column, row: row)

    let x: CGFloat = gridStartX + (itemSize * CGFloat(item.column))
    let y: CGFloat = gridStartY + (itemSize * CGFloat(item.row))

    item.position = CGPoint(x: x, y: y)
    item.size = CGSize(width: itemSize, height: itemSize)

    addChild(item)
        
    return item
```
```swift
private var columns: [[Item]] = []

private func createGrid() {
    for x in 0..<itemsPerRow {
        var column = [Item]()
            
        for y in 0..<itemsPerColumn {
            let item = createItem(column: x, row: y)
            column.append(item)
        }
        
        columns.append(column)
    }
}
```
### 📌 터치 이벤트 처리
`touchesBegan` 메소드를 통해 터치된 위치를 감지하여 해당 위치에 있는 고양이 노드와 주변 노드를 검사하였습니다.
```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
        
    let location = touch.location(in: self)
    guard let tappedItem = findItem(point: location) else { return }

    // ... tappedItem과 주변 item 검사, 제거, item 재생성 로직 ... //
}
```
### 📌 SKAction으로 애니메이션 구현
화면 위에서 고양이 노드가 내려오는 애니메이션을 `SKAction.move`로 구현했습니다.
```swift
let position = positionItem(for: item)

let downAction = SKAction.move(to: position, duration: 0.3)
item.run(downAction)
```
### 📌 SKAudioNode로 효과음 구현
게임 배경음악과 고양이 퍼즐이 터질 때 효과음을 넣어 UX를 향상시켰습니다.
- 배경음악 : 오토플레이를 활성화하여 화면에 진입하자마자 자동 재생
```swift
private let backgroundMusic: SKAudioNode = {
    let node = SKAudioNode(fileNamed: "backgroundMusic")
        
    node.isPositional = false
    node.autoplayLooped = true
        
    return node
}()
```
- 효과음 : 고양이가 터질 때 한번만 재생(반복X)해야 하므로, `SKAction.play()`로 작동
```swift
private let popSound: SKAudioNode = {
    let node = SKAudioNode(fileNamed: Assets.popSound.rawValue)
        
    node.isPositional = false
    node.autoplayLooped = false
        
    return node
}()

// ... //

func removeMatches() {
    // ... 퍼즐 매칭 로직 ... //

    popSound.run(SKAction.play())
}
```
### 📌 노드로 버튼 구현
배경음악 on/off 토글 버튼을 커스텀 `SKSpriteNode`를 통해 구현했습니다. 노드 클래스 내부에서 `touchesBegan`, `touchesEnded`를 호출할 경우 씬에서의 position 검사가 필요없어 버튼으로 구현하기 편합니다. 버튼 액션은 콜백 함수로 호출합니다.
```swift
class MusicButton: SKSpriteNode {
    private var isMusicOn: Bool = true {
        didSet {
            toggleImage()
        }
    }

    // ... //

    var buttonAction: ((Bool) -> Void)?

    private func toggleImage() {
        let imageName = isMusicOn ? Assets.musicOn.rawValue : Assets.musicOff.rawValue
        
        texture = SKTexture(imageNamed: imageName)
        
        alpha = isMusicOn ? 1.0 : 0.8
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(0.9)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        setScale(1.0)
        
        isMusicOn.toggle()
        buttonAction?(isMusicOn)
    }
}
```
```swift
class GameScene: SKScene {
    // ... //

    private func addMusicButton() {
        // ... //

        musicButton.buttonAction = { [weak self] isMusicOn in
            isMusicOn
            ? self?.backgroundMusic.run(SKAction.play())
            : self?.backgroundMusic.run(SKAction.pause())
        }
        
        addChild(musicButton)
    }
}
```
## 트러블슈팅
### ⚠️ SKLabelNode 레이아웃 문제
#### ☹️ 문제
<img src="https://github.com/user-attachments/assets/9f37e3be-55a1-4b6c-a39c-a1fa5c74baad" width=400>

점수, 남은 횟수 레이블이 제자리에 유지되지 않고 텍스트 길이에 따라 움직이는 현상
#### 🧐 원인
- `SKLabelNode`의 레이아웃 속성인 `horizontalAlignmentMode`의 기본값이 `.center`
- 이 속성은 텍스트의 정렬이 아니라 노드의 `position`에 대한 고정축을 결정하는 값
- `.center`에서는 텍스트 중앙이 `position`에 고정되기 때문에 텍스트가 길어짐에 따라 좌우로 확장되어 레이블이 움직여 보였던 것
#### 😇 해결
`horizontalAlignmentMode`의 값을 점수 레이블은 `.left`, 남은 횟수 레이블은 `.right`로 지정
#### 😎 성과
- `SKLabelNode`의 `alignmentMode` 속성이 단순 텍스트 정렬이 아니라 `position`에 대한 기준점을 정의하는 속성임을 정확히 이해하게 됨
- `UIKit`의 오토레이아웃 개념과 `SpriteKit`에서의 레이아웃 방식은 다르다는 것을 경험
- `SpriteKit`으로 개발할 때 `position` 기준점을 명확히 정의하는 것의 중요성을 깨닫는 계기가 되었음
