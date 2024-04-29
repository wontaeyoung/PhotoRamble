<!--
 기술 사용 설명 파트 수정
 
 조금 더 기술의 정의보다 내 프로젝트에서 어떻게 구현되어있는지를 설명하는 느낌으로 워딩이랑 문장 수정
 -> Coordinator 패턴을 사용해서 뷰모델에서
 
볼드 헤더 없애고, 기술 사용 설명보다 신경써서 구현한 부분이라는 느낌의 섹션 이름으로 변경
 
중요한 내용 위주로 10개 이하로 남겨서 나열식으로 변경
 
ex) Alamofire를 사용할 때 URLRequestConvitible을 활용한 Router 패턴을 구현해서 Request 추상화

---

아키텍처 이미지와 설명

-->

# 스크린샷

![산책일기_스크린샷](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/3ba87274-8e62-40ed-b0be-5b0e78b093fc)


<br>

# 한 줄 소개

산책하면서 사진을 찍고 일기와 함께 기록할 수 있는 앱

<br>

# 핵심 기능

- 사진 촬영
- 산책 시간 체크
- 일기 작성 / 조회 / 삭제

<br>

# 프로젝트 환경

**개발 인원**  
1인

<br>

**개발 기간**  
2024.03.08 ~ 2024.03.26 (2.5주)

> 업데이트 진행 중

> 작업 기간을 3일 단위로 나누고 작업마다 예상 소요시간과 실제 소요시간을 기록하면서 작업을 진행했습니다.

<br>

## 개발 환경

**iOS 최소 버전**  
15.0+

<br>

**Xcode**  
15.3

<br>

**기타 사항**
- 다국어 대응
- 디자인 시스템 적용

<br><br>

# 기술 스택

### 프레임워크 / 라이브러리
- UIKit / SnapKit / Compositional Layout
- Realm / RxSwift
- Firebase Analytics / Crashlytics
- FSPager / IQKeyboard / Toast

<br>

### 아키텍처
MVVM / Clean Architecture

<br>

### 디자인 패턴
Coordinator / Singleton / Repository / Router

<br><br>

# 기술 사용 설명

**Realm**

- FK를 활용해서 To-One 관계 정의
- CRUD 로직을 추상화한 Service 객체 구현

**Coordinator Pattern**

- 뷰컨트롤러에서 화면 전환 및 의존성 주입 역할 분리
- 화면 전환 로직 추상화
- Output 결과가 화면 전환일 때 뷰모델에서 화면 전환 요청


**Router**

- 파일 시스템에 요청하기 위한 Request 구조 추상화
- 디렉토리 / 파일 경로 획득 로직 재활용


**Analytics / Crashlytics**

- 사용자 이탈 지점 파악 후 업데이트 반영
- 충돌 데이터 수집 결과를 활용하여 버그 개선


**컴파일 최적화**

- final / 접근제어자를 사용해서 인라인 컴파일과 정적 디스패치 유도


**디자인 시스템**

- UI 스타일을 열거형 케이스로 관리해서 일관적인 디자인 사용
- 디자인 속성 변경사항이 일괄적으로 반영되는 구조로 구현


**Base UI**

- 뷰컨트롤러, 셀을 상속한 Base 클래스를 사용해서 일관된 코드 구조 작성
- UI 컴포넌트별로 상속받은 커스텀 컴포넌트를 구현해서 사용


<br>

# 트러블 슈팅

	
### 파일시스템 용량 확보를 위한 이미지 압축 로직 적용

- 촬영한 사진이 원본으로 저장될 경우 앱 저장공간을 크게 차지하는 문제가 발생하여, 파일시스템에 저장되기 전에 이미지 파일을 압축했습니다.
- 압축 로직은 용량이 2MB 이하가 될 때까지 압축률을 10%씩 증가시켜서 시도하는 방식으로 구현했습니다.

**적용 전**

![image](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/eb4cebeb-9254-48fc-869e-92fd585bd5a4)


**적용 후**

![image](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/d1bcef1b-58e3-40d7-b903-fa4383181635)


<br>

<details>
    <summary> 압축 로직 코드 </summary>
    
```swift
import UIKit

extension UIImage {
  var compressedJPEGData: Data? {
    let maxQuality: CGFloat = 1.0
    let minQuality: CGFloat = 0.0
    let maxSizeInBytes = BusinessValue.maxImageFileVolumeMB * 1024 * 1024
    
    // 최대 품질(무압축)에서 시작
    var compressionQuality: CGFloat = maxQuality
    
    // 이미지를 JPEG 데이터로 변환
    guard var compressedData = self.jpegData(compressionQuality: compressionQuality) else { return nil }
    
    /// 용량이 최대 기준치 이하가 되었거나, 압축률이 100%가 아니면 반복 수행
    while Double(compressedData.count) > maxSizeInBytes && compressionQuality > minQuality {
      // 압축률 10% 증가 후 다시 시도
      compressionQuality -= 0.1
      
      guard let newData = self.jpegData(compressionQuality: compressionQuality) else { break }
      compressedData = newData
    }
    
    return compressedData
  }
}
    
```
    
</details>

<br><br>

### 객체 관심사 분리

![image](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/712eaff0-3aa4-4076-826d-a926274a4f6e)

- 클린아키텍처를 참고해서 적용했습니다.
- 수정과 재사용에 유리하도록 고민하면서 구현했습니다.

<br><br>

<details>
    <summary> 객체 분리 코드 예시 </summary>

```swift
final class CreateDiaryUsecaseImpl: CreateDiaryUsecase {
  
  ...
  
  // MARK: - Method
  func execute(with diary: Diary) -> Single<Diary> {
    return diaryRepository.create(with: diary)
  }
}
```

- Usecase가 하나의 비즈니스 작업만 수행하도록 분리해서, 단일 책임을 준수하고 가독성과 재사용성을 확보했습니다.

<br><br>

```swift
protocol WalkRepository {
  
  func create(with walk: Walk) -> Single<Walk>
  func fetch(walkID: UUID) -> Single<Walk>
}

final class CreateWalkUsecaseImpl: CreateWalkUsecase {
  
  // MARK: - Property
  private let walkRepository: any WalkRepository
  
  // MARK: - Initializer
  init(walkRepository: some WalkRepository) {
    self.walkRepository = walkRepository
  }
  
  ...
}

```

- 인터페이스 프로토콜 추상화로 구현체 변경에 영향을 받지 않도록 구성했습니다.

</details>

<br><br>

<!--

### 이미지 메모리 용량 다운샘플링 - (기능 업데이트 후 작성 예정)
- 압축된 이미지 파일로 UIImage를 표시해도 메모리에서 원본 용량을 차지하는 문제
- 표시 이미지 메모리 감소를 위해서는 해상도 다운샘플링 및 이미지 버퍼 제거가 필요한 점 학습 내용 포함

<details>
    <summary>참고 이미지</summary>
    
![image](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/ee0fde18-3499-4aa2-89d3-5651fc1621d4)


![image](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/b9d1add0-92a0-47bd-a7ee-9b7d481e964e)


![image](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/d8929d5d-81ba-4f0f-a80e-2a89b37dba42)


</details>

<br><br>

### 파일시스템 Replace 정합성 예외처리 - (기능 업데이트 후 작성 예정)
- Replace 로직
    1. 폴더 내 이미지 파일 전체 삭제
    2. 사용자가 선택한 사진들로 다시 생성
- 2번 과정에서 실패하는 경우 전체 작업을 취소하고 이미지 삭제 전으로 복구하는 예외처리 필요



<br><br>

### DI Container 도입 - (기능 업데이트 후 작성 예정)
- 의존성 주입 코드량 감소 수치 작성
- 참조 객체 재활용성

<br><br>

-->

## 개발 작업 공수 기록
![image](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/83a29ce2-5fda-4112-b2ea-25d81cf22a80)

- 작업 히스토리와 예정 작업을 나열해서 우선순위를 판단하는데 활용했습니다.
- 작업에 대한 예상 소요시간과 실제 작업시간을 비교해서 어떤 부분에서 시간을 소요하는지 스스로 파악하는데 활용했습니다.

<br><br>

## 업데이트 예정 사항

- 산책 데이터에 날씨, 이동거리 정보 추가
- 위치 기반 
    - 산책 경로 표시
    - 집 근처 도착 시 산책 종료 제안 표시
- 일기 검색 / 필터
- 일기 북마크
