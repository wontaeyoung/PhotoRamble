# 프로젝트 - [AppStore](https://apps.apple.com/kr/app/%EC%82%B0%EC%B1%85%EC%9D%BC%EA%B8%B0/id6479728861)

### 스크린샷

![산책일기_스크린샷_변경](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/c638c83c-45ae-4ee3-afb1-5a0a27404744)

### 한 줄 소개

산책하면서 사진을 찍고 일기와 함께 기록할 수 있는 앱

<br>

### 서비스 기능

- 사진 촬영 기능
- 산책 시간 체크 기능
- 이미지 다중 선택 기능
- 일기 작성 / 조회 / 삭제 기능

<br>

## 프로젝트 환경

**개발 인원**  
iOS/기획/디자인 1인

**개발 기간**  
2024.03.08 ~ 2024.03.26 (2.5주)

> 작업 기간을 3일 단위로 나누고 작업마다 예상 소요시간과 실제 소요시간을 기록하면서 작업을 진행

<br>

## 개발 환경

**iOS 최소 버전**  
15.0+

**Xcode**  
15.3

**기타 사항**
- 다국어 대응
- 디자인 시스템 적용

<br>

## 기술 스택

- **`UIKit`** **`SnapKit`** **`CompositionalLayout`**
- **`MVVM`** **`Input&Output`** **`Coordinator`** **`RxSwift`**
- **`Realm`** **`Firebase Analytics`** **`Crashlytics`**
- **`FSPager`** **`IQKeyboard`** **`Toast`**

<br>

## 구현 고려사항

- **final** 키워드로 상속이 필요하지 않은 클래스에 **Static Dispatch** 유도
- 접근 제어를 최소 권한으로 유지하여 **은닉화** 달성
- **앱 저장공간과 메모리 최적화**를 위한 파일 압축 처리 및 이미지 리사이징 적용
- 디자인 시스템으로 **UI 일관성** 유지
- Repository 인터페이스를 의존하여 **DIP** 적용
- Router와 FileManager를 구현하여 파일시스템 **API 추상화**

<br>

## 기술 활용

### 앱스토어 강제 업데이트 체크 로직 적용

- Itunes API 버전 조회를 활용하여 클라이언트 앱 버전과 비교하는 로직을 앱 런치 시점에 검사
- Major 버전이 다른 경우 팝업으로 유도하여, 대형 업데이트를 사용자가 즉시 반영할 수 있도록 활용 가능

<img src="https://github.com/wontaeyoung/PhotoRamble/assets/45925685/d599c6f1-cfe0-4e67-93c9-11c2ea585f46" width="300">

<br>
<br>

### Router를 활용한 파일시스템 요청 추상화

- PhotoFileRouter 객체를 정의하여 파일시스템 요청 구조화
- Repository에서 Router를 사용하여 FileManager에 파일시스템 처리 요청
- FileManager에서 Router의 Sugar API를 사용하여 조건 체크

<img src="https://github.com/wontaeyoung/PhotoRamble/assets/45925685/60238b0d-2b7d-4afb-8c70-1ecd3a3bfd7a" width="500"><br>

<details>
  <summary>Router 구현 코드</summary>

```swift
struct PhotoFileRouter {
  
  enum FileExtension: String, CaseIterable {
    
    case jpg
    case png
    
    var name: String {
      return ".\(self.rawValue)"
    }
  }
  
  enum CompressionLevel {
    
    case high
    case middle
    case low
    case raw
    
    var percent: CGFloat {
      switch self {
        case .high:
          return 0.25
        case .middle:
          return 0.5
        case .low:
          return 0.75
        case .raw:
          return 1
      }
    }
  }
  
  enum FileMethod {
    
    case write
    case read
    case delete
  }
  
  
  // MARK: - Property
  let directory: String
  let fileIndex: Int
  let fileExtension: FileExtension
  let fileMethod: FileMethod
  
  init(directory: String, fileIndex: Int, fileExtension: FileExtension, fileMethod: FileMethod) {
    
    self.directory = directory
    self.fileIndex = fileIndex
    self.fileExtension = fileExtension
    self.fileMethod = fileMethod
  }
  
  var baseDirectory: URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  }
  
  var path: String {
    return "photo/\(directory)"
  }
  
  var directoryURL: URL {
    return baseDirectory.appendingPathComponent(path)
  }
  
  var fileName: String {
    return directory + "_\(fileIndex)" + fileExtension.name
  }
  
  var fileURL: URL {
    return directoryURL.appendingPathComponent(fileName)
  }
  
  var directoryPath: String {
    return directoryURL.path
  }
  
  var filePath: String {
    return fileURL.path
  }
  
  var directoryExist: Bool {
    return FileManager.default.fileExists(atPath: directoryPath)
  }
  
  var fileExist: Bool {
    return FileManager.default.fileExists(atPath: filePath)
  }
}

```
  
</details>

<br><br>

## 아키텍처

![image](https://github.com/wontaeyoung/PhotoRamble/assets/45925685/a1414ad4-e82d-4e8c-abcb-52d65f4d78d2)

<br>

## 트러블 슈팅

### 파일시스템 용량 최적화를 위한 이미지 압축 로직 적용

- 촬영된 사진이 원본으로 저장되면서 앱 저장공간을 과도하게 점유하는 문제 발생 
- 파일 시스템 저장 시점에 이미지 파일 압축 처리 적용
- 압축 로직은 이미지 용량이 2MB 이하로 감소할 때까지 압축률을 10%씩 점진적으로 증가하는 방식으로 구현

<img src="https://github.com/wontaeyoung/PhotoRamble/assets/45925685/0a142e77-de8e-4f2e-9c56-56b58282db41" width="600">

<br><br>


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

<br>

### UIImage 리사이징 메모리 최적화

- 이미 압축된 Data를 UIImage로 변환 시, 압축 전과 유사한 메모리 용량을 사용하는 문제 경험
- JPEG 압축 과정에서 해상도가 아닌 시각적으로 인식하기 어려운 색상 및 세부 정보가 우선 손실되는 정책이 원인으로 파악
- UIImage를 화면에 렌더링하는 시점에 해상도 기반 리사이징을 적용하여 메모리 사용량 개선


<img src="https://github.com/wontaeyoung/PhotoRamble/assets/45925685/7c072feb-dc1c-4b88-a880-e4f475212386" width="500">

<br><br>

<!--


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
