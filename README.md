# GridPopGame (고양이 퍼즐 게임)
같은 색깔의 고양이 퍼즐을 터뜨리는 게임입니다.
- `SpriteKit`으로 구현
- 개발과정을 담은 포스팅 시리즈 : https://velog.io/@emilyj4482/series/GridPopGame

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
고양이 이미지 노드의 경우 전역변수로 선언하지 않고 메소드 내에서 반복적으로 생성하며 8x8 그리드 형태로 포지셔닝을 하였습니다. 이 때, 행/열 좌표값을 사용하여 이미지 크기를 고려한 `position`을 계산해야 하므로 2차배열을 전역변수로 선언하였습니다.
```swift

```

### 📌 터치 이벤트 처리

### 📌 SKAction으로 애니메이션 구현

### 📌 SKAudioNode로 효과음 구현

### 📌 Node로 버튼 구현

## 트러블슈팅
### ⚠️ SKLabelNode 레이아웃 문제
