# V1 Flutter App: Create Real-Estate Listing ("Tạo Tin Đăng") Feature Analysis

## 1. Create-Listing Flow: Stepper Structure

**File:** `/Users/mac/Developer/tongkhobds_agent/lib/features/create_news/enums/create_news_step.dart` (lines 1-42)

**Stepper has 4 STEPS:**

```dart
enum CreateNewStep { one, tow, three, four }

extension CreateNewsStepExt on CreateNewStep {
  String get title {
    switch (this) {
      case CreateNewStep.one:
        return "Bước 1: Thông tin BĐS";  // Step 1: Real Estate Information
      case CreateNewStep.tow:
        return "Bước 2: Đăng hình ảnh, Video";  // Step 2: Upload Images, Videos
      case CreateNewStep.three:
        return "Bước 3: Xác nhận thông tin";  // Step 3: Confirm Information
      case CreateNewStep.four:
        return "Bước 4: Xác nhận hoa hồng";  // Step 4: Confirm Commission
    }
  }
}
```

### Step Details:

| Step | Enum | Title | Purpose |
|------|------|-------|---------|
| 1 | `CreateNewStep.one` | "Bước 1: Thông tin BĐS" | Collect property information (type, area, price, location, description, dynamic fields per property type) |
| 2 | `CreateNewStep.tow` | "Bước 2: Đăng hình ảnh, Video" | Upload house images (min. 4), legal documents, and videos |
| 3 | `CreateNewStep.three` | "Bước 3: Xác nhận thông tin" | Review and confirm all property details before submission |
| 4 | `CreateNewStep.four` | "Bước 4: Xác nhận hoa hồng" | **Set commission percentage (hoa hồng)** within calculated min/max range |

**Step 4 Specifics** (`confirm_rose_screen.dart`):
- Displays commission (hoa hồng) input field
- Shows min/max commission range (fetched from server)
- User enters % value within range
- Validation ensures value is within `commissionMin` and `commissionMax`
- Contains educational text about commission benefits

---

## 2. Additional Dynamic Fields ("Các trường mô tả thêm")

**Files:**
- Form model: `/Users/mac/Developer/tongkhobds_agent/lib/features/create_news/models/giu_form_model.dart` (lines 1-41)
- Rendering: `/Users/mac/Developer/tongkhobds_agent/lib/features/create_news/step_view/step_one.dart` (lines 705-870)
- Controller: `/Users/mac/Developer/tongkhobds_agent/lib/features/create_news/create_news_controller.dart` (lines 154, 1507-1518)

### How Additional Fields Are Fetched:

**API Endpoint:** `GET /api_customer/get_property_type_fields?property_type_id={id}`

**Controller method** (line 1507-1518):
```dart
fetchMota(int id) async {
  await apiClient
      .getPropertyTypeFields(id: id)
      .then((response) {
        if (response.data["data"] != null) {
          formGuide.value = GiuFormModel.fromJson(response.data["data"]);
        }
      })
      .catchError((error, trace) {
        ErrorUtil.catchError(error, trace);
      });
}
```

**API Client implementation** (api_client.dart, lines 1416-1420):
```dart
Future<Response> getPropertyTypeFields({required int id}) async {
  return client.get(
    "$apiCustomer/get_property_type_fields?property_type_id=$id",
  );
}
```

### Form Model Structure:

```dart
@JsonSerializable(explicitToJson: true)
class GiuFormModel extends BaseModel {
  final int? id;
  final String? title;
  final List<GiuFieldModel> fieldsArray;  // Dynamic fields list
}

@JsonSerializable()
class GiuFieldModel {
  final String? title;
  final String? type;  // Field type: determines UI rendering
}
```

### Supported Field Types (Rendered in `step_one.dart`):

| Field Type | Rendering | Controller |
|------------|-----------|-----------|
| `legal_document_type` | Bottom sheet selector | `legalDocController` |
| `bedrooms` | Counter UI | `bedrooms` Rx value |
| `bathrooms` | Counter UI | `bathrooms` Rx value |
| `num_of_floors` | Counter UI | `numOfFloor` Rx value |
| `floors` | Counter UI | `floors` Rx value |
| `floor_block` | Counter UI | `blocks` Rx value |
| `house_direction` | Bottom sheet (HouseDirectionSheet) | `houseDirectionController` |
| `balcony_direction` | Bottom sheet (HouseDirectionSheet) | `balconyDirectionController` |
| `land_direction` | Bottom sheet (HouseDirectionSheet) | `landController` |
| `interior` | Bottom sheet (furniture list) | `furnitureController` |
| `frontage`, `road_width`, `management_fee`, `zone_of_project`, `residential_agricultural_ratio`, `building_density`, `construction_area`, `campus_area`, `ceiling_height`, `door_size`, `access_door_size`, `business_type` | Text input field | Respective controllers |

### Field-to-Controller Mapping (step_one.dart, lines 839-850):
```dart
case "frontage":
case "road_width":
case "management_fee":
// ... etc.
  final textController = getTextController(model.type ?? "");
  final focusNode = getFocusNode(model.type ?? "");
  return TitleDefaultTextField(
    controller: textController,
    focusNode: focusNode,
    // ...
  );
```

**Response Example:** Fields vary by property type. When user selects property type, `fetchMota()` is called to populate dynamic fields specific to that type.

---

## 3. Auto-Generate Listing Content

**Files:**
- Controller: `/Users/mac/Developer/tongkhobds_agent/lib/features/create_news/create_ai/create_ai_controller.dart` (lines 93-187)
- Request model: `/Users/mac/Developer/tongkhobds_agent/lib/features/create_news/models/create_content_ai.dart`

### API Endpoint:

**Method:** `POST`  
**Path:** `/api/generate_real_estate_sample.json`  
**Full URL:** `https://quanly.tongkhobds.com/tongkho/api/generate_real_estate_sample.json`

**API Client method** (api_client.dart, lines 872-877):
```dart
Future<Response> createPostAi(CreateContentAi data) async {
  return client.post(
    '$apiCommon/generate_real_estate_sample.json',
    data: data.toJson(),
  );
}
```

### Request Payload Shape:

**Model:** `CreateContentAi` (create_content_ai.dart, lines 54-80)

```dart
Map<String, dynamic> toJson() {
  return {
    'title': title,
    'price': price,
    'min_price': minPrice,
    'max_price': maxPrice,
    'property_type_id': propertyTypeId,
    'description': description,
    'furniture': furniture,
    'bedrooms': bedrooms,
    'bathrooms': bathrooms,
    'floors': floors,
    'house_direction': houseDirection,
    'balcony_direction': balconyDirection,
    'transaction_type': transactionType,  // 1=sell, 2=rent
    'city': city,
    'district': district,
    'ward': ward,
    'street_name': streetName,
    'street_address': streetAddress,
    'legal_document_type': legalDocumentType,
    "content": content,
    "length": length,  // "auto" or specific length
    "tone": tone,      // "auto" or specific tone
    "use_ai": useAi,
  };
}
```

### How Result Is Inserted:

**Implementation** (create_ai_controller.dart, lines 93-187):

```dart
Future<void> createContentAi() async {
  // ... build CreateContentAi request ...
  try {
    const maxAttempts = 6;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final response = await apiClient.createPostAi(request);  // Line 157
      final parsed = _parseAiResponse(response);
      
      if (parsed.isSuccess) {
        final html = parsed.html!;
        descriptionController.text = AppUtil().convertHtmlToPlainText(html);  // Line 161: Insert to description
        htmlContent.value = html;  // Line 162: Store HTML
        if (parsed.title != null) {
          titleController.text = parsed.title!;  // Line 164: Update title if provided
        }
        DialogUtil.showSuccessMessage("Tạo nội dung thành công");
        return;
      }
      // Polling logic for async processing...
    }
  }
}
```

### Response Parsing:

```dart
_AiResponse _parseAiResponse(dynamic response) {
  if (response.statusCode != 200) return error response;
  
  final root = response.data;  // Map
  final status = root['status'];  // 0=processing, 1=success
  final payload = root['data'];   // Map
  
  if (payload is Map) {
    final html = (payload['data'] ?? '').toString();      // Generated HTML description
    final title = (payload['title'] ?? '').toString();    // Generated/suggested title
    // ...
  }
}
```

**Flow:**
1. User clicks "Tạo nội dung tự động" in create AI step
2. System calls `createPostAi()` with property details
3. Server processes async request (polling up to 6 times)
4. When ready, HTML result extracted from response
5. HTML auto-converted to plain text → `descriptionController.text`
6. HTML also stored → `htmlContent.value` (for quill editor)
7. User can accept or edit before posting

---

## 4. Final Submit: "Đăng Tin" (Post Listing)

**Files:**
- Controller submit method: `/Users/mac/Developer/tongkhobds_agent/lib/features/create_news/create_news_controller.dart` (lines 909-1041)
- API endpoint: `/Users/mac/Developer/tongkhobds_agent/lib/domain/client/api_client.dart` (lines 868-870)

### API Endpoint:

**Method:** `POST`  
**Path:** `/api_agent/save_real_estate.json`  
**Full URL:** `https://quanly.tongkhobds.com/tongkho/api_agent/save_real_estate.json`

**API Client implementation** (api_client.dart, lines 868-870):
```dart
Future<Response> createPost(Map<String, dynamic> data) async {
  return client.post('$apiHostReal/save_real_estate.json', data: [data]);
}
```

**Note:** Request body is wrapped in an array `[data]`

### Full Request Payload Shape:

**Built in `createPost()` method** (create_news_controller.dart, lines 929-997):

```dart
final data = {
  "id": product.value.id,                                    // int: 0 for new, existing ID for edit
  "title": titleText.value,                                   // string: listing title
  "price": int.tryParse(customerPriceText.value...) ?? 0,    // int: asking price (đồng)
  "return_price": int.tryParse(netPriceText.value...) ?? 0,  // int: net price for agent
  "property_type_id": selectedPropertyType.value?.id ?? 0,   // int: property type ID
  "description": descriptionText.value.isNotEmpty ? ... : ..., // string: plain text description
  "bedrooms": bedrooms.value,                                  // int
  "bathrooms": bathrooms.value,                                // int
  "floors": floors.value,                                      // int
  "num_of_floors": numOfFloor.value,                           // int
  "floor_block": blocks.value,                                 // int
  "house_direction": selectedHouseDirection.value?.label ?? "", // string: e.g., "Đông", "Tây"
  "balcony_direction": selectedBalcony.value?.label ?? "",     // string
  "transaction_type": demandType.value!.index + 1,             // int: 1=sell, 2=rent
  "city": selectedCoty.value,                                   // string: city name
  "district": selectedDistrict.value,                           // string: district/county name
  "ward": selectedCommune.value,                                // string: ward/commune name
  "city_id": resolvedCityId,                        // string (optional): city ID if available
  "district_id": resolvedDistrictId,                // string (optional): district ID
  "ward_id": resolvedWardId,                        // string (optional): ward ID
  "street_name": streetController.value,                       // string: street name
  "street_address": fullAddress,                               // string: complete address (house# + street + ward/district/city)
  "legal_document_type": selectedLegalDocumentType.value?.name ?? "", // string: e.g., "Sổ đỏ"
  "furniture": furnitureController.text,                        // string: e.g., "Đủ tiện nghi"
  "zone_of_project": int.tryParse(...) ?? 0,                  // int
  "management_fee": int.tryParse(...) ?? 0,                   // int: monthly fee (đồng)
  "frontage": int.tryParse(...) ?? 0,                         // int: frontage meters
  "road_width": int.tryParse(...) ?? 0,                       // int: road width meters
  "building_density": buildingDensityController.text,          // string
  "residential_agricultural_ratio": residentialAgriculturalRatioController.text, // string
  "construction_area": int.tryParse(...) ?? 0,                // int: m²
  "campus_area": int.tryParse(...) ?? 0,                      // int: m²
  "business_type": bussController.text,                        // string
  "area": int.tryParse(areaText.value...) ?? 0,               // int: total area (m²)
  "images": jsonEncode(uploadedHouseImages),                   // JSON array string: image URLs
  "main_image": uploadedHouseImages.isNotEmpty ? uploadedHouseImages.first : '', // string: primary image URL
  "video_url": jsonEncode(uploadedVideos),                     // JSON array string: video URLs
  "legal_document_url": uploadedLegalDocs.isNotEmpty ? uploadedLegalDocs.first : null, // string: legal doc URL
  "save_status": status,                                       // string: "PENDING_APPROVAL" or "DRAFT"
  "total_rate": double.parse(roseController.text),             // double: commission %
  "land_direction": huongDatDirectionText.value,               // string: land direction
  "ceiling_height": int.tryParse(...) ?? 0,                   // int
  "door_size": int.tryParse(...) ?? 0,                        // int
  "access_door_size": int.tryParse(...) ?? 0,                 // int
  "html_content": htmlContent.value,                           // string: HTML formatted description
  "latlng": "${lat.value}, ${lng.value}",                      // string: "latitude, longitude"
};
```

### Request Filtering:

Before submission, empty/zero values are stripped (lines 999-1005):

```dart
final filteredParams = {
  for (final entry in data.entries)
    if (entry.value != null &&
        entry.value.toString().trim().isNotEmpty &&
        entry.value != 0)
      entry.key: entry.value.toString(),
};
```

**All values converted to strings** (`.toString()`) before sending.

### Image/Video Upload:

**Upload happens BEFORE final post submission** (separate step in Step 2):

**Endpoint:** `POST /api_customer/upload_file.json`

**Implementation** (api_client.dart, lines 835-837):
```dart
Future<Response> uploadFile(FormData formData) async {
  return client.post('$apiCustomer/upload_file.json', data: formData);
}
```

**Request Structure:** Multipart/form-data
```dart
FormData.fromMap({
  'file': [
    await dio.MultipartFile.fromFile(file.path, filename: file.name),
    // ... multiple files ...
  ],
});
```

**Response Parsing** (lines 1406-1435):
```dart
List<String> _extractUploadUrls(dynamic responseData) {
  // Extracts URLs from response['data']['urls'], response['message'], etc.
  // Returns list of uploaded file URLs
}
```

Uploaded URLs stored in:
- `uploadedHouseImages` (List<String>)
- `uploadedVideos` (List<String>)
- `uploadedLegalDocs` (List<String>)

Then embedded in final post payload as JSON strings.

### Submission Flow:

```dart
createPost({String? status = "PENDING_APPROVAL"}) {
  // 1. Build payload (see above)
  // 2. Filter empty values
  // 3. POST to save_real_estate.json
  // 4. On success: navigate to DefaultScreen showing success/posted status
  // 5. Fire ProductEvent to refresh listing
}
```

---

## Summary Table

| Aspect | Details |
|--------|---------|
| **Stepper Steps** | 4 steps: Info (1), Media (2), Review (3), Commission (4) |
| **Dynamic Fields API** | `GET /api_customer/get_property_type_fields?property_type_id={id}` |
| **Dynamic Fields Model** | `GiuFormModel` with `fieldsArray: List<GiuFieldModel>` |
| **Auto-Generate Endpoint** | `POST /api/generate_real_estate_sample.json` |
| **Auto-Generate Request** | `CreateContentAi` with 25+ fields (property details + length/tone) |
| **Auto-Generate Response** | `{status, data: {data: "<html>...", title: "..."}}` |
| **Final Submit Endpoint** | `POST /api_agent/save_real_estate.json` |
| **Final Submit Method** | POST with request body = `[{...fields...}]` (wrapped in array) |
| **Final Submit Payload** | 35+ fields including images/videos as JSON strings, all values stringified |
| **Image Upload** | `POST /api_customer/upload_file.json` (multipart/form-data) before final post |
| **Image Upload Response** | URLs extracted from `data.urls`, `message`, or `data` field |

