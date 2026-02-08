# Sakan Mobile API Documentation

Complete API reference for mobile app integration - from user registration to booking management.

## Base URL

```
http://localhost:8000/api/v1/
```

## Interactive API Documentation

The API includes interactive documentation powered by OpenAPI/Swagger:

| URL | Description |
|-----|-------------|
| `/api/docs/` | Swagger UI - Interactive API explorer |
| `/api/redoc/` | ReDoc - Alternative documentation view |
| `/api/schema/` | OpenAPI JSON schema |

**Features:**
- Try out API endpoints directly in the browser
- View request/response schemas
- Filter endpoints by tags
- Persistent authorization (enter your token once)

## Authentication

All endpoints (except registration/login) require token-based authentication:

```
Authorization: Token <your_auth_token>
```

---

## Table of Contents

0. [App Configuration (Splash Screen)](#0-app-configuration-splash-screen)
1. [User Registration & Authentication](#1-user-registration--authentication)
2. [Person Profiles (Student/Employee)](#2-person-profiles-studentemployee)
3. [Daklia (Property) Endpoints](#3-daklia-property-endpoints)
4. [Rooms Management](#4-rooms-management)
5. [Room Features](#5-room-features)
6. [Services](#6-services)
7. [Rules/Laws](#7-ruleslaws)
8. [Booking Management](#8-booking-management)
9. [Notifications](#9-notifications)
10. [Location Management](#10-location-management)
11. [Complaints & Suggestions](#11-complaints--suggestions)
12. [Status Codes & Error Handling](#12-status-codes--error-handling)
13. [Mobile App Flow](#13-mobile-app-flow)

---

## 0. App Configuration (Splash Screen)

This endpoint should be called on the **Splash Screen** before any authentication to check app status.

**Supports two apps:**
- `sakan-customer` - Customer app for students/employees
- `sakan-service-provider` - Service provider app for Daklia owners

### 0.1 Get App Configuration

Returns maintenance mode status, version requirements, and store URLs for the specified app.

**Endpoint:** `GET /api/app-configuration/?app_type={customer|provider}`

**Authentication:** Not required (public endpoint)

**Query Parameters:**

| Parameter | Required | Values | Description |
|-----------|----------|--------|-------------|
| `app_type` | Yes | `customer` or `provider` | Which app's configuration to retrieve |

**Examples:**
- Customer app: `GET /api/app-configuration/?app_type=customer`
- Service Provider app: `GET /api/app-configuration/?app_type=provider`

**Success Response (200 OK):**

```json
{
  "min_android_version": "1.0.0",
  "min_ios_version": "1.0.0",
  "current_active_version": "1.2.3",
  "is_maintenance_mode": false,
  "maintenance_message": "We will be back soon. We're doing some maintenance.",
  "store_urls": {
    "android": "https://play.google.com/store/apps/details?id=com.sakan.customer",
    "ios": "https://apps.apple.com/app/sakan-customer"
  },
  "is_force_update": false
}
```

| Field | Type | Description |
|-------|------|-------------|
| `min_android_version` | string | Minimum required Android app version |
| `min_ios_version` | string | Minimum required iOS app version |
| `current_active_version` | string | Currently recommended/active version |
| `is_maintenance_mode` | boolean | If `true`, show maintenance screen and block access |
| `maintenance_message` | string | Message to display during maintenance |
| `store_urls` | object | Store URLs for app updates |
| `is_force_update` | boolean | If `true`, user must update and cannot skip |

**Error Response (400 Bad Request):**

```json
{
  "error": "Invalid or missing app_type parameter",
  "message": "app_type must be 'customer' or 'provider'",
  "valid_values": ["customer", "provider"]
}
```

### Mobile Client Behavior:

1. **If `is_maintenance_mode == true`:**
   - Show full-screen maintenance screen
   - Display `maintenance_message`
   - Block all further access

2. **Else if user's app version < `min_android_version` / `min_ios_version`:**
   - Show non-dismissible update dialog
   - Link to appropriate store URL
   - If `is_force_update == true`: User CANNOT skip
   - If `is_force_update == false`: User CAN optionally dismiss

3. **Else:** Proceed with normal app flow

### Version Comparison:

Compare as semantic versions (major.minor.patch):
```
Split on '.', compare each segment as integers from left to right.
Example: "1.2.3" vs "1.2.10" → 1.2.10 is greater
```


---

## 1. User Registration & Authentication

### 1.1 Register User

Creates a new user account and returns authentication token.

**Endpoint:** `POST /api/v1/user/create`

**Authentication:** Not required

**Request Body:**

```json
{
  "username": "john_doe",
  "phone_number": "+1234567890",
  "password": "securepassword123",
  "confirm_password": "securepassword123",
  "user_type": 0,
  "is_active": 1,
  "is_staff": 0,
  "is_superuser": 0
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `username` | string | Yes | Unique username, max 20 characters |
| `phone_number` | string | Yes | Unique phone number, min 10 digits |
| `password` | string | Yes | Min 8 characters |
| `confirm_password` | string | Yes | Must match password |
| `user_type` | integer | Yes | 0 = regular user, 1 = daklia owner |
| `is_active` | integer | No | 1 = active (default) |
| `is_staff` | integer | No | 0 = not staff (default) |
| `is_superuser` | integer | No | 0 = not superuser (default) |

**Success Response (201 Created):**

```json
{
  "message": "Account created successfully",
  "id": 1,
  "username": "john_doe",
  "phone_number": "+1234567890",
  "user_type": 0,
  "is_active": true,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "is_staff": false,
  "is_superuser": false,
  "token": "abc123token456def",
  "otp": "123456"
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 400 | Validation Error (See examples below) |
| 400 | "Phone number is required" |
| 400 | "Phone Number already exists" |

**Detailed 400 Bad Request Examples:**

*   **Validation Errors (Individual or Combined):**

    ```json
    {
      "password": [
        "Password and ConfirmPassword must match."
      ],
      "phone_number": [
        "Phone number must be 10 digits.",
        "Phone number already exist."
      ],
      "username": [
        "Username already exist."
      ]
    }
    ```

    *Possible messages:*
    - `{"password": "Password and ConfirmPassword must match."}`
    - `{"password": "Password must be at least 8 characters."}`
    - `{"confirm_password": "ConfirmPassword must be at least 8 characters."}`
    - `{"phone_number": "Phone number must be 10 digits."}`
    - `{"phone_number": "Phone number already exist."}`
    - `{"username": "Username already exist."}`

*   **Missing Phone Number:**

    ```json
    {
      "message": "Phone number is required"
    }
    ```

*   **Phone Number Already Exists (User Check):**

    ```json
    {
      "message": "Phone Number already exists"
    }
    ```

---

### 1.2 User Login

Authenticates user and returns token.

**Endpoint:** `POST /api/v1/user/login`

**Authentication:** Not required

**Request Body:**

```json
{
  "phone_number": "+1234567890",
  "password": "securepassword123"
}
```

**Success Response (200 OK):**

```json
{
  "message": "Login successfully",
  "id": 1,
  "username": "john_doe",
  "phone_number": "+1234567890",
  "user_type": 0,
  "is_active": true,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z",
  "is_staff": false,
  "is_superuser": false,
  "token": "abc123token456def",
  "is_verified": true,
  "Daklia_id": 5
}
```

**Notes:**
- `is_verified` indicates if phone number has been verified via OTP
- `Daklia_id` only present if user is a Daklia owner (user_type = 1)
- If account not verified, must call `/verify-code` endpoint

**Error Responses:**

| Status | Message |
|--------|---------|
| 404 | "User does not exist" |
| 401 | "Wrong password" |
| 401 | "Account does not active" |
| 400 | "Account does not verified" (returns OTP) |

---

### 1.3 Send OTP

Requests a verification code to be sent to phone number.

**Endpoint:** `POST /api/v1/user/send-otp`

**Authentication:** Not required

**Request Body:**

```json
{
  "phone_number": "+1234567890"
}
```

**Success Response (200 OK):**

```json
{
  "message": "OTP sent successfully",
  "otp": "123456",
  "phone_number": "+1234567890",
  "user_id": 1
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 404 | "Phone Number does not exist" |
| 400 | "User is not active" |

---

### 1.4 Verify OTP

Verifies the OTP code sent to user's phone.

**Endpoint:** `POST /api/v1/user/verify-code`

**Authentication:** Not required

**Request Body:**

```json
{
  "phone_number": "+1234567890",
  "otp": "123456"
}
```

**Success Response (200 OK):**

```json
{
  "message": "OTP verified successfully",
  "is_verified": true,
  "user_id": 1,
  "username": "john_doe",
  "phone_number": "+1234567890"
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 404 | "Phone Number does not exist" |
| 400 | "OTP is incorrect" |
| 400 | "OTP must be 6 digits" |
| 400 | "User is not active" |

---

### 1.5 Change Password (Authenticated)

Changes password for authenticated user.

**Endpoint:** `PUT /api/v1/user/change-password`

**Authentication:** Required

**Request Body:**

```json
{
  "phone_number": "+1234567890",
  "password": "oldpassword123",
  "new_password": "newpassword456"
}
```

**Success Response (200 OK):**

```json
{
  "message": "Password Changed successfully"
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 404 | "Phone Number does not exist" |
| 400 | "Wrong password" |
| 400 | "New Password must be at least 8 characters" |
| 400 | "New password cannot be the same as old password" |

---

### 1.6 Reset Password

Resets password without authentication (after OTP verification).

**Endpoint:** `PUT /api/v1/user/reset-password`

**Authentication:** Not required

**Request Body:**

```json
{
  "phone_number": "+1234567890",
  "password": "newpassword456"
}
```

**Success Response (200 OK):**

```json
{
  "message": "Password Reset successfully"
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 404 | "Phone Number does not exist" |
| 400 | "Password must be at least 8 characters" |
| 400 | "Password is same as old password" |

---

### 1.7 Logout

Invalidates the user's authentication token.

**Endpoint:** `POST /api/v1/user/logout`

**Authentication:** Required

**Request Body:** Empty

**Success Response (200 OK):**

```json
{
  "message": "logout successful"
    "message": "logout successful"
}
```

---

### 1.8 Update FCM Token (NEW)
Registers the device for push notifications.

**Endpoint:** `POST /api/v1/person/profile/update-fcm-token/`

**Authentication:** Required

**Request Body:**
```json
{
  "fcm_token": "firebase_device_token_string"
}
```

**Success Response (200 OK):**
```json
{
  "message": "FCM token updated successfully"
}
```

---

## 2. Person Profiles (Student/Employee)

### 2.1 Register Student Profile

Creates a student profile linked to user account.

**Endpoint:** `POST /api/v1/person/register_student/`

**Authentication:** Not required (typically after user registration)

**Content-Type:** `multipart/form-data`

**Request Body:**

| Field | Type | Required | Description |
|-------|------|-------------|-------------|
| `user_id` | integer | Yes | ID of registered user account |
| `full_name` | string | No | Full name (auto-populated from username) |
| `birth_of_date` | string | No | Date of birth (YYYY-MM-DD) |
| `guardian_number` | string | No | Guardian's phone number |
| `university_name` | string | No | University name |
| `id_number` | string | No | National ID number |
| `identification_card` | file | No | Student ID document |
| `guardian_card` | file | No | Guardian's ID document |

**Success Response (201 Created):**

```json
{
  "message": "successfully register Student",
  "data": {
    "student_id": 1,
    "user_id": 1,
    "full_name": "John Doe",
    "birth_of_date": "2000-01-15",
    "guardian_number": "+1234567890",
    "university_name": "Princess Sumaya University",
    "id_number": "406070664",
    "identification_card": null,
    "guardian_card": null
  }
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 400 | "user_id is required" |
| 400 | "User already exist" |
| 404 | "User does not exist" |

---

### 2.2 Register Employee Profile

Creates an employee profile linked to user account.

**Endpoint:** `POST /api/v1/person/register_employee/`

**Authentication:** Not required

**Content-Type:** `multipart/form-data`

**Request Body:**

| Field | Type | Required | Description |
|-------|------|-------------|-------------|
| `user_id` | integer | Yes | ID of registered user account |
| `full_name` | string | No | Full name (auto-populated from username) |
| `work_place` | string | No | Current employer/workplace |
| `birth_of_date` | string | No | Date of birth (YYYY-MM-DD) |
| `guardian_number` | string | No | Guardian's phone number |
| `id_number` | string | No | National ID number |
| `identification_card` | file | No | Employee ID document |
| `guardian_card` | file | No | Guardian's ID document |

**Success Response (201 Created):**

```json
{
  "message": "successfully register Employee",
  "data": {
    "employee_id": 1,
    "user_id": 2,
    "full_name": "Jane Smith",
    "work_place": "Tech Corporation",
    "birth_of_date": "1990-05-20",
    "guardian_number": "+1234567891",
    "id_number": "987654321",
    "identification_card": null,
    "guardian_card": null
  }
}
```

---

### 2.3 Get User Profile

Retrieves the authenticated user's profile information.

**Endpoint:** `GET /api/v1/person/profile/`

**Authentication:** Required

**Success Response (200 OK):**

```json
{
  "user_id": 1,
  "username": "john_doe",
  "phone_number": "+1234567890",
  "user_type": 0,
  "is_verified": true,
  "full_name": "John Doe",
  "guardian_number": "+1234567891",
  "id_number": "406070664",
  "birth_of_date": "2000-01-15",
  "university_name": "Princess Sumaya University",
  "work_place": null,
  "identification_card": "https://example.com/media/images/id.pdf",
  "guardian_card": "https://example.com/media/images/guardian.pdf",
  "profile_type": "student"
}
```

| Field | Type | Description |
|-------|------|-------------|
| `profile_type` | string | "student" or "employee" |
| `university_name` | string | Only for students |
| `work_place` | string | Only for employees |

**Error Responses:**

| Status | Message |
|--------|---------|
| 401 | Unauthorized |
| 404 | "User profile not found. Please register as student or employee first." |

---

### 2.4 Update User Profile

Updates the authenticated user's profile information.

**Endpoint:** `PUT /api/v1/person/profile/update/`

**Authentication:** Required

**Content-Type:** `multipart/form-data`

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `full_name` | string | No | User's full name |
| `guardian_number` | string | No | Guardian's phone number |
| `id_number` | string | No | National ID number |
| `birth_of_date` | string | No | Date of birth (YYYY-MM-DD) |
| `university_name` | string | No | University name (students only) |
| `work_place` | string | No | Workplace (employees only) |
| `identification_card` | file | No | ID document upload |
| `guardian_card` | file | No | Guardian ID document upload |

**Success Response (200 OK):**

```json
{
  "message": "Profile updated successfully",
  "data": {
    "full_name": "Updated Name",
    "guardian_number": "+1234567890",
    "id_number": "406070664",
    "birth_of_date": "2000-01-15",
    "university_name": "Updated University",
    "profile_type": "student"
  }
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 401 | Unauthorized |
| 404 | "User profile not found. Please register as student or employee first." |

---

## 3. Daklia (Property) Endpoints

### 3.1 Create Daklia Account

Creates a new property listing. User must have user_type = 1.

**Endpoint:** `POST /api/v1/daklia/daklia-info/`

**Authentication:** Required

**Request Body:**

```json
{
  "daklia_description": "Modern student accommodation with 20 rooms",
  "numberOfRooms": 20,
  "daklia_image": null
}
```

**Success Response (201 Created):**

```json
{
  "Daklia_id": 1,
  "user_id": 1,
  "daklia_name": "john_doe",
  "daklia_description": "Modern student accommodation with 20 rooms",
  "numberOfRooms": 20,
  "is_active": true,
  "subscription_status": "free",
  "account_status": 0
}
```

**Notes:**
- `daklia_name` is auto-set to user's username
- `account_status = 0` means pending verification
- One Daklia per user only

---

### 3.2 Get All Active Daklias

Returns all active property listings.

**Endpoint:** `GET /api/v1/person/get-all-dakliaat/`

**Authentication:** Required

**Success Response (200 OK):**

```json
{
  "daklias": [
    {
      "Daklia_id": 123,
      "daklia_name": "Student Housing Complex",
      "daklia_image": "https://example.com/image.jpg",
      "daklia_description": "Modern student accommodation",
      "numberOfRooms": 50,
      "account_status": 1,
      "is_active": true,
      "can_receive_bookings": true,
      "booking_status": "available",
      "subscription_status": "free",
      "subscription_display": "Free Plan",
      "address": "123 University Ave",
      "rooms_count": 20,
      "services_count": 8,
      "laws_count": 12,
      "owner_username": "daklia_owner",
      "user_id": 456
    }
  ],
  "total_count": 15,
  "available_count": 12,
  "pending_verification_count": 3
}
```

---

### 3.3 Search Daklias

Search properties by name.

**Endpoint:** `GET /api/v1/person/search-dakliaat/?daklia_name=housing`

**Authentication:** Required

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `daklia_name` | string | Property name to search (case-insensitive) |

**Response:** Same format as Get All Daklias

---

### 3.4 Get Daklia Public Profile

Returns basic public information (no contact details).

**Endpoint:** `GET /api/v1/daklia/daklia-profile/<id>/`

**Authentication:** Required

**URL Parameters:**
- `id` (integer): Daklia ID

**Success Response (200 OK):**

```json
{
  "Daklia_id": 123,
  "daklia_name": "Student Housing Complex",
  "daklia_image": "https://example.com/image.jpg",
  "daklia_description": "Modern student accommodation",
  "numberOfRooms": 50,
  "account_status": 1,
  "room_count": 45,
  "service_count": 8,
  "law_count": 12,
  "user_id": 456,
  "location_id": 789,
  "address": "123 University Ave"
}
```

**Error Response:**

| Status | Message |
|--------|---------|
| 404 | "Daklia does not exist or is not available" |

---

### 3.5 Get Daklia Sensitive Information

Returns contact details and exact coordinates. **Requires approved booking.**

**Endpoint:** `GET /api/v1/daklia/daklia-sensitive/<id>/`

**Authentication:** Required

**Access Rules:**
- Admin users: Always have access
- Regular users: Only with approved booking for this Daklia

**Success Response (200 OK):**

```json
{
  "Daklia_id": 123,
  "daklia_name": "Student Housing Complex",
  "mobile_number": "+1234567890",
  "email": "owner@studenthousing.com",
  "longitude": "40.7128",
  "latitude": "-74.0060",
  "full_address": "123 University Ave, Floor 2",
  "access_granted_reason": "User has approved booking for this Daklia",
  "sensitive_data": true
}
```

**Error Responses:**

| Status | Message | Code |
|--------|---------|------|
| 404 | "Daklia does not exist" | - |
| 403 | "Access denied. You need an approved booking to view sensitive Daklia information" | BOOKING_REQUIRED |

---

### 3.6 Get Daklia Info

Returns general Daklia information.

**Endpoint:** `GET /api/v1/person/<daklia_id>/get-daklia-info/`

**Authentication:** Required


---

### 3.7 Update Daklia Profile with Multiple Images

Updates Daklia profile information and optionally **uploads multiple images**.

**Endpoint:** `PUT /api/v1/daklia/<id>/update-profile/`

**Authentication:** Required (Daklia owner only)

**Content-Type:** `multipart/form-data`

**Request Body:**

| Field | Type | Description |
|-------|------|-------------|
| `daklia_description` | string | Property description |
| `numberOfRooms` | integer | Number of rooms |
| `daklia_image` | file | **Single main image (backward compatible)** |
| `images[]` | file[] | **Multiple images (NEW!)** - Upload multiple files |

**Example:**
```bash
curl -X PUT http://localhost:8000/api/v1/daklia/1/update-profile/ \
  -H "Authorization: Token YOUR_TOKEN" \
  -F "daklia_description=Modern accommodation" \
  -F "daklia_image=@main.jpg" \
  -F "images[]=@gallery1.jpg" \
  -F "images[]=@gallery2.jpg" \
  -F "images[]=@gallery3.jpg"
```

**Success Response (200 OK):**

```json
{
  "Daklia_id": 1,
  "daklia_name": "owner_name",
  "daklia_description": "Modern accommodation",
  "numberOfRooms": 20,
  "daklia_image": "/media/images/main.jpg",
  ...
}
```

**Note:** Similar to rooms, new images are stored separately and can be retrieved via the GET Daklia profile endpoint.

---

## 4. Rooms Management


### 4.1 Add Room

Adds a new room to a Daklia with support for **multiple images**.

**Endpoint:** `POST /api/v1/daklia/rooms/add/`

**Authentication:** Required (Daklia owner only)

**Content-Type:** `multipart/form-data`

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `room_number` | integer | Yes | Room number/identifier |
| `room_type` | string | Yes | Type (Single, Double, Suite) |
| `daily_booking` | boolean | No | Allow daily booking |
| `monthly_booking` | boolean | No | Allow monthly booking |
| `price_per_month` | float | No | Monthly rental price |
| `price_per_day` | float | No | Daily rental price |
| `numberOfBeds` | integer | No | Total beds in room |
| `num_Available_Beds` | integer | No | Currently available beds |
| `room_image` | file | No | **Single room image (backward compatible)** |
| `images[]` | file[] | No | **Multiple images (NEW!)** - Upload multiple files |

**New Feature - Multiple Images:**
- You can now upload multiple images for each room
- Use `images[]=file1&images[]=file2&images[]=file3` in your request
- Images are automatically ordered by upload sequence
- Both `room_image` and `images[]` can be used together
- Existing apps using only `room_image` continue to work

**cURL Example:**
```bash
curl -X POST http://localhost:8000/api/v1/daklia/rooms/add/ \
  -H "Authorization: Token YOUR_TOKEN" \
  -F "room_number=101" \
  -F "room_type=Single" \
  -F "numberOfBeds=2" \
  -F "price_per_month=5000" \
  -F "room_image=@main_photo.jpg" \
  -F "images[]=@photo1.jpg" \
  -F "images[]=@photo2.jpg" \
  -F "images[]=@photo3.jpg"
```

**Success Response (201 Created):**

```json
{
  "room_id": 1,
  "daklia_id": 1,
  "room_number": 101,
  "room_type": "Single",
  "daily_booking": false,
  "monthly_booking": true,
  "price_per_month": 5000.0,
  "price_per_day": 20.0,
  "numberOfBeds": 2,
  "num_Available_Beds": 2,
  "room_image": "/media/images/main_photo.jpg"
}
```

**Note:** The response doesn't immediately include the `images` array. To see all uploaded images, use the GET room details endpoint (see section 4.4).

---

### 4.2 Get Rooms Count

**Endpoint:** `GET /api/v1/daklia/<id>/rooms/count/`

**Authentication:** Required

**Response:**

```json
{
  "room_count": 20
}
```

---

### 4.3 Get All Rooms (with Availability Filtering)

Retrieves all rooms for a Daklia with **optional availability filtering**.

**Endpoint:** `GET /api/v1/daklia/<id>/rooms/`

**Authentication:** Required

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `start_date` | string | No | Start date for availability check (YYYY-MM-DD format) |
| `end_date` | string | No | End date for availability check (YYYY-MM-DD format) |
| `only_available` | boolean | No | Set to `true` to filter only available rooms |

**Availability Filtering Logic:**

When `only_available=true` or a date range is provided, rooms are **excluded** if:

1. **Fully Booked Status:** The room has `num_Available_Beds <= 0` (marked as unavailable)
2. **No Empty Beds for Date Range:** The count of active, confirmed bookings for that room within the requested date range equals or exceeds the total number of beds

**Booking Overlap Detection:**
A booking is considered overlapping if:
```
booking_start_date <= requested_end_date AND booking_end_date >= requested_start_date
```

Only bookings with `booking_status='approved'` and `cancel_status=False` are counted.

**Example Requests:**

```bash
# Get all rooms (no filtering)
GET /api/v1/daklia/1/rooms/

# Get only available rooms (basic filter)
GET /api/v1/daklia/1/rooms/?only_available=true

# Get rooms available for a specific date range
GET /api/v1/daklia/1/rooms/?start_date=2026-02-01&end_date=2026-02-28

# Combined filtering
GET /api/v1/daklia/1/rooms/?only_available=true&start_date=2026-02-01&end_date=2026-02-28
```

**Success Response (200 OK):**

```json
[
  {
    "room_id": 1,
    "daklia_id": 1,
    "room_number": 101,
    "room_type": "Single",
    "daily_booking": false,
    "monthly_booking": true,
    "price_per_month": 5000.0,
    "price_per_day": 20.0,
    "numberOfBeds": 2,
    "num_Available_Beds": 1,
    "room_image": "https://example.com/room.jpg",
    "images": [
      {
        "image_id": 1,
        "image_url": "https://example.com/room1.jpg",
        "order": 0
      }
    ]
  }
]
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 400 | "Invalid start_date format. Use YYYY-MM-DD." |
| 400 | "Invalid end_date format. Use YYYY-MM-DD." |
| 404 | "Daklia does not exist" |

---

### 4.4 Get Room Details

Retrieves detailed room information **including all uploaded images**.

**Endpoint:** `GET /api/v1/daklia/<daklia_id>/rooms/<room_id>/details/`

**Authentication:** Required

**Success Response (200 OK):**

```json
{
  "room_id": 1,
  "daklia_id": 1,
  "room_number": 101,
  "room_type": "Single",
  "daily_booking": false,
  "monthly_booking": true,
  "price_per_month": 5000.0,
  "price_per_day": 20.0,
  "numberOfBeds": 2,
  "num_Available_Beds": 2,
  "room_image": "https://s3.amazonaws.com/sakan-s3-bucket/images/main_photo.jpg",
  "images": [
    {
      "image_id": 1,
      "room": 1,
      "image": "images/photo1.jpg",
      "image_url": "https://s3.amazonaws.com/sakan-s3-bucket/images/photo1.jpg",
      "caption": null,
      "order": 0,
      "uploaded_at": "2025-12-14T17:30:00Z"
    },
    {
      "image_id": 2,
      "room": 1,
      "image": "images/photo2.jpg",
      "image_url": "https://s3.amazonaws.com/sakan-s3-bucket/images/photo2.jpg",
      "caption": null,
      "order": 1,
      "uploaded_at": "2025-12-14T17:30:01Z"
    }
  ]
}
```

**New `images` Array Fields:**
- `image_id`: Unique ID for each image
- `image_url`: Full absolute URL to the image (use this for displaying)
- `order`: Display order (0 is first, 1 is second, etc.)
- `caption`: Optional description (null if not set)
- `uploaded_at`: Timestamp when image was uploaded

---

### 4.5 Edit Room

Updates room information and optionally **adds more images**.

**Endpoint:** `PUT /api/v1/daklia/<daklia_id>/rooms/<room_id>/`

**Authentication:** Required (Daklia owner only)

**Content-Type:** `multipart/form-data`

**Request Body:**

All fields from "Add Room" are supported, plus:

| Field | Type | Description |
|-------|------|-------------|
| `images[]` | file[] | **Add more images to existing room** |

**Example - Add More Images:**
```bash
curl -X PUT http://localhost:8000/api/v1/daklia/1/rooms/1/ \
  -H "Authorization: Token YOUR_TOKEN" \
  -F "price_per_month=5500" \
  -F "images[]=@new_photo1.jpg" \
  -F "images[]=@new_photo2.jpg"
```

**Response (200 OK):**

```json
{
  "message": "Room updated successfully",
  "data": {
    "room_id": 1,
    "room_number": 101,
    "price_per_month": 5500.0,
    ...
  }
}
```

**Note:** New images are appended to existing images. To see all images, call the GET room details endpoint.

---

### 4.6 Delete Room

**Endpoint:** `DELETE /api/v1/daklia/<daklia_id>/rooms/<room_id>/delete/`

**Authentication:** Required (Daklia owner only)

**Response (204 No Content):**

```json
{
  "message": "Room deleted successfully"
}
```

---

## 5. Room Features

### 5.1 Add Room Feature

**Endpoint:** `POST /api/v1/daklia/<daklia_id>/rooms/features/add/`

**Authentication:** Required

**Request Body:**

```json
{
  "room_id": 1,
  "feature_name": "Air Conditioning",
  "feature_description": "Central AC with temperature control"
}
```

**Success Response (201 Created):**

```json
{
  "feature_id": 1,
  "room_id": 1,
  "feature_name": "Air Conditioning",
  "feature_description": "Central AC with temperature control"
}
```

---

### 5.2 Get Room Features

**Endpoint:** `GET /api/v1/daklia/<daklia_id>/rooms/<room_id>/features/`

**Authentication:** Required

---

### 5.3 Edit Room Feature

**Endpoint:** `PUT /api/v1/daklia/<daklia_id>/rooms/<room_id>/features/<feature_id>/`

**Authentication:** Required

---

### 5.4 Delete Room Feature

**Endpoint:** `DELETE /api/v1/daklia/<daklia_id>/rooms/<room_id>/features/<feature_id>/delete/`

**Authentication:** Required

---

## 6. Services

### 6.1 Add Service

**Endpoint:** `POST /api/v1/daklia/services/add/`

**Authentication:** Required

**Request Body:**

```json
{
  "daklia_id": 1,
  "service_name": "Laundry Service",
  "service_description": "Weekly laundry service included",
  "service_type": "Utility",
  "isAvailable": true,
  "service_price": 10.0
}
```

**Success Response (201 Created):**

```json
{
  "service_id": 1,
  "daklia_id": 1,
  "service_name": "Laundry Service",
  "service_description": "Weekly laundry service included",
  "service_type": "Utility",
  "isAvailable": true,
  "service_price": 10.0
}
```

---

### 6.2 Get Services Count

**Endpoint:** `GET /api/v1/daklia/<id>/services/count/`

**Authentication:** Required

---

### 6.3 Get All Services

**Endpoint:** `GET /api/v1/daklia/<id>/services/`

**Authentication:** Required

---

### 6.4 Get Service Details

**Endpoint:** `GET /api/v1/daklia/<daklia_id>/services/<service_id>/details/`

**Authentication:** Required

---

### 6.5 Edit Service

**Endpoint:** `PUT /api/v1/daklia/<daklia_id>/services/<service_id>/`

**Authentication:** Required

---

### 6.6 Delete Service

**Endpoint:** `DELETE /api/v1/daklia/<daklia_id>/services/<service_id>/delete/`

**Authentication:** Required

---

## 7. Rules/Laws

### 7.1 Add Law/Rule

**Endpoint:** `POST /api/v1/daklia/<daklia_id>/laws/add/`

**Authentication:** Required

**Request Body:**

```json
{
  "daklia_id": 1,
  "law_description": "No smoking in rooms",
  "punishment_description": "Fine of $50 for violation"
}
```

**Success Response (201 Created):**

```json
{
  "law_id": 1,
  "daklia_id": 1,
  "law_description": "No smoking in rooms",
  "punishment_description": "Fine of $50 for violation"
}
```

---

### 7.2 Get Laws Count

**Endpoint:** `GET /api/v1/daklia/<id>/laws/count/`

**Authentication:** Required

---

### 7.3 Get All Laws

**Endpoint:** `GET /api/v1/daklia/<id>/laws/`

**Authentication:** Required

---

### 7.4 Get Law Details

**Endpoint:** `GET /api/v1/daklia/<daklia_id>/laws/<law_id>/details/`

**Authentication:** Required

---

### 7.5 Edit Law

**Endpoint:** `PUT /api/v1/daklia/<daklia_id>/laws/<law_id>/`

**Authentication:** Required

---

### 7.6 Delete Law

**Endpoint:** `DELETE /api/v1/daklia/<daklia_id>/laws/<law_id>/delete/`

**Authentication:** Required

---

  "booking_status": "pending",
  "can_receive_bookings": true,
  "is_active": true,
  "owner_username": "daklia_owner",
  "owner_user_id": 456
}
```

---

## 8. Booking Management

### 8.1 Create Booking
Initiates a new booking.

**Endpoint:** `POST /api/v1/person/create-new-booking/`

**Authentication:** Required

**Request Body:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `room_id` | integer | Yes | Room ID |
| `student_id` | integer | No | Student profile ID (if booking as student) |
| `employee_id` | integer | No | Employee profile ID (if booking as employee) |
| `start_date` | date | Yes | YYYY-MM-DD |
| `end_date` | date | Yes | YYYY-MM-DD |
| `invoice_receipt` | file | **No (Optional)** | Proof of payment/deposit |

**Changes:**
- `invoice_receipt` is now optional.
- Booking status defaults to `pending`.
- Daklia Owner will receive a notification to approve/reject.

**Success Response (201 Created):**
```json
{
  "message": "Booking created successfully and is pending owner approval",
  "booking_id": 123,
  "status": "pending"
}
```

### 8.2 Owner Booking Action (NEW)
Approve or Reject a booking (For Daklia Owners).

**Endpoint:** `POST /api/v1/person/owner/bookings/{booking_id}/action/`

**Authentication:** Required (Must be Daklia Owner)

**Request Body:**
```json
{
  "action": "approve" // or "reject"
  "reason": "optional reason for rejection"
}
```

### 8.3 Owner Get Bookings (NEW)
Retrieve all bookings for the Daklia owned by the authenticated user.

**Endpoint:** `GET /api/v1/person/owner/bookings/`

**Authentication:** Required (Must be Daklia Owner)

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `status` | string | No | Filter by booking status (pending, approved, rejected, cancelled) |

**Success Response (200 OK):**
```json
{
  "message": "Bookings retrieved successfully",
  "count": 3,
  "data": [
    {
      "booking_id": 1,
      "room_id": 1,
      "student_id": 5,
      "daklia_id": 1,
      "start_date": "2025-01-01",
      "end_date": "2025-01-30",
      "booking_status": "pending",
      "beds_booked": 1,
      "booking_time": "2024-12-20T10:00:00Z",
      "customer_name": "john_doe",
      "customer_type": "Student",
      "customer_phone": "+1234567890"
    }
  ]
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 403 | "You are not a Daklia owner" |
| 404 | "No Daklia found for this user" |


### 8.1 Create New Booking

Creates a booking request (pending admin approval).

**Endpoint:** `POST /api/v1/person/create-new-booking/`

**Authentication:** Required

**Content-Type:** `multipart/form-data` (required for file upload)

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `room_id` | integer | Yes | Room ID to book |
| `student_id` | integer | Conditional | Student profile ID (if student) |
| `employee_id` | integer | Conditional | Employee profile ID (if employee) |
| `start_date` | string | Yes | Check-in date (YYYY-MM-DD) |
| `end_date` | string | Yes | Check-out date (YYYY-MM-DD) |
| `total_price` | float | Yes | Total booking cost |
| `beds_booked` | integer | No | Number of beds booked |
| `transaction_id` | string | No | Payment/transaction reference |
| `invoice_receipt` | file | **Yes** | Payment receipt (PDF, image) |

> **Important:** Either `student_id` or `employee_id` is required, not both.

**Success Response (201 Created):**

```json
{
  "message": "Booking created successfully and is pending admin approval",
  "booking_id": 1,
  "status": "pending",
  "data": {
    "booking_id": 1,
    "room_id": 1,
    "student_id": 1,
    "daklia_id": 1,
    "start_date": "2024-01-15",
    "end_date": "2024-01-30",
    "total_price": 500.0,
    "beds_booked": 1,
    "booking_status": "pending",
    "transaction_id": "TXN123456",
    "booking_time": "2024-01-10T14:30:00Z",
    "invoice_receipt": "/media/invoices/receipt.pdf",
    "payment_status": false,
    "cancel_status": false
  }
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 400 | "Either student_id or employee_id is required" |
| 400 | "Invoice receipt is required for booking" |
| 400 | "This Daklia is not currently accepting bookings" |
| 400 | "Room is already booked for these dates" |
| 404 | "Room not found" |

**Validation Rules:**
- `invoice_receipt` file upload is **mandatory**
- Daklia must be active (`is_active = true`) and verified (`account_status = 1`)
- No overlapping bookings for same room
- Booking starts in "pending" status

---

### 8.2 Get Booking Details

**Endpoint:** `GET /api/v1/person/bookings/<booking_id>/`

**Authentication:** Required

**Success Response (200 OK):**

```json
{
  "message": "successfully get booking details",
  "data": {
    "booking_id": 1,
    "room_id": 1,
    "student_id": 1,
    "daklia_id": 1,
    "start_date": "2024-01-15",
    "end_date": "2024-01-30",
    "total_price": 500.0,
    "beds_booked": 1,
    "booking_status": "pending",
    "transaction_id": "TXN123456",
    "booking_time": "2024-01-10T14:30:00Z",
    "invoice_receipt": "/media/invoices/receipt.pdf",
    "payment_status": false,
    "cancel_status": false,
    "discount_id": null,
    "employee_id": null,
    "is_student": true,
    "is_employee": false,
    "admin_action_by": null,
    "admin_action_date": null,
    "rejection_reason": null,
    "admin_notes": null,
    "cancel_date": null,
    "customer_name": "john_doe",
    "customer_type": "Student"
  }
}
```

**Booking Status Values:**

| Status | Description |
|--------|-------------|
| `pending` | Awaiting admin approval |
| `approved` | Confirmed by admin |
| `rejected` | Declined by admin (check `rejection_reason`) |
| `cancelled` | Cancelled by user |

---

### 8.4 Cancel Booking (NEW)

Cancel a booking. Can be performed by the **student** who made the booking, the **employee** who made it, or the **Daklia owner** of the property. Only **pending** or **approved** bookings can be cancelled. Idempotent: if already cancelled, returns 200 with `already_cancelled: true`.

**Endpoint:** `POST /api/v1/person/bookings/<booking_id>/cancel/`

**Authentication:** Required (Token)

**Who can cancel:**
- **Student** – only if they are the booking’s customer (`booking.student_id` is their profile)
- **Employee** – only if they are the booking’s customer (`booking.employee_id` is their profile)
- **Daklia owner** – only if they own the property of the booking (`booking.room_id.daklia_id` is their Daklia)

**URL Parameters:**

| Parameter   | Type    | Description   |
|------------|---------|---------------|
| `booking_id` | integer | Booking ID to cancel |

**Request Body (optional):**

```json
{
  "reason": "Change of plans"
}
```

| Field   | Type   | Required | Description                    |
|--------|--------|----------|--------------------------------|
| `reason` | string | No       | Optional reason for cancellation (stored as admin_notes) |

**Success Response (200 OK):**

```json
{
  "message": "Booking cancelled successfully",
  "booking_id": 40,
  "booking_status": "cancelled"
}
```

**Success Response when already cancelled (200 OK, idempotent):**

```json
{
  "message": "Booking cancelled successfully",
  "booking_id": 40,
  "booking_status": "cancelled",
  "already_cancelled": true
}
```

**Error Responses:**

| Status | Message |
|--------|---------|
| 403 | "You are not allowed to cancel this booking. Only the customer (student/employee) or the Daklia owner can cancel." |
| 404 | "Booking not found." |
| 400 | "Only pending or approved bookings can be cancelled." |
| 400 | "Cannot cancel a rejected booking." |

**Notifications:**
- When the **Daklia owner** cancels → the **customer** (student or employee) receives a push notification: "تم إلغاء حجزك لـ {daklia_name} من قبل مالك السكن." (`data.type`: `booking_cancelled`, `data.cancelled_by`: `owner`).
- When the **student or employee** cancels → the **Daklia owner** receives a push notification: "تم إلغاء حجز لـ {daklia_name} من قبل العميل." (`data.type`: `booking_cancelled`, `data.cancelled_by`: `customer`).

**Example:**

```bash
curl -X POST "https://api.example.com/api/v1/person/bookings/40/cancel/" \
  -H "Authorization: Token YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"reason": "Change of plans"}'
```

---

## 9. Notifications

Notifications are stored when push notifications are sent (e.g. booking approval, subscription activation). The API returns the in-app notification history for the authenticated user (customer or owner).

### 9.1 List Notifications

**Endpoint:** `GET /api/v1/person/notifications/`

**Authentication:** Required (Token)

**Query Parameters:**

| Parameter   | Type    | Required | Description                                |
|-------------|---------|----------|--------------------------------------------|
| `page`      | integer | No       | Page number (default: 1)                   |
| `page_size` | integer | No       | Items per page (default: 20, max: 100)    |
| `is_read`   | boolean | No       | Filter by read status (`true` / `false`)  |

**Success Response (200 OK):**

```json
{
  "count": 45,
  "next": "https://api.example.com/api/v1/person/notifications/?page=2&page_size=20",
  "previous": null,
  "results": [
    {
      "notification_id": 1,
      "title": "تم تفعيل الاشتراك!",
      "body": "تم تفعيل اشتراك شهري لـ سكن الرشيد بنجاح.",
      "data": {
        "type": "subscription_activated",
        "subscription_id": "123",
        "daklia_id": "5"
      },
      "is_read": false,
      "created_at": "2026-02-07T10:30:00Z",
      "read_at": null
    }
  ]
}
```

| Field           | Type    | Description                                      |
|-----------------|---------|--------------------------------------------------|
| `notification_id` | integer | Unique notification ID                         |
| `title`         | string  | Notification title                              |
| `body`          | string  | Notification body text                          |
| `data`          | object  | Extra payload (e.g. `type`, `booking_id`)       |
| `is_read`       | boolean | Whether the user has marked it as read         |
| `created_at`    | string  | ISO 8601 timestamp when notification was sent  |
| `read_at`       | string  | ISO 8601 timestamp when marked read (or null)  |

### 9.2 Mark Notification as Read

**Endpoint:** `PATCH /api/v1/person/notifications/{notification_id}/read/`

**Alternative:** `POST /api/v1/person/notifications/{notification_id}/read/`

**Authentication:** Required (Token)

**URL Parameters:**

| Parameter        | Type   | Description       |
|------------------|--------|-------------------|
| `notification_id` | integer | Notification ID   |

**Success Response (200 OK):**

```json
{
  "message": "Notification marked as read"
}
```

**Error Response (404 Not Found):** Notification does not exist or does not belong to the authenticated user.

---

## 10. Location Management

### 10.1 Create/Update Daklia Location

**Endpoint:** `POST /api/v1/daklia/daklia-location/`

**Authentication:** Required

**Request Body:**

```json
{
  "user_id": 1,
  "longitude": "40.7128",
  "latitude": "-74.0060",
  "address": "123 University Ave, Student District",
  "additional_address": "Building B, Floor 2"
}
```

**Success Response (201 Created):**

```json
{
  "location_id": 1,
  "user_id": 1,
  "longitude": "40.7128",
  "latitude": "-74.0060",
  "address": "123 University Ave, Student District",
  "additional_address": "Building B, Floor 2"
}
```

---

### 10.2 Verify Daklia Account

Uploads verification documents for Daklia account.

**Endpoint:** `POST /api/v1/daklia/verify-account/`

**Authentication:** Required

**Content-Type:** `multipart/form-data`

**Request Body:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `Daklia_id` | integer | Yes | Daklia ID to verify |
| `daklia_license` | file | Yes | Business license document |
| `owner_idenfication_card` | file | Yes | Owner's ID document |

---

## 11. Complaints & Suggestions

User feedback system for submitting complaints and suggestions.

### 11.1 List/Create Complaints

**Endpoint:** `GET /api/v1/feedback/complaints/` | `POST /api/v1/feedback/complaints/`

**Authentication:** Required

**GET - Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `status` | string | Filter by status (pending, in_progress, resolved, closed, rejected) |
| `category` | string | Filter by category |

**GET Response (200 OK):**

```json
{
  "message": "Complaints retrieved successfully",
  "count": 5,
  "data": [
    {
      "complaint_id": 1,
      "user": 1,
      "user_name": "john_doe",
      "daklia": 5,
      "daklia_name": "Student Housing",
      "subject": "Room maintenance issue",
      "description": "The AC in my room is not working properly",
      "category": "property",
      "category_display": "Property Issue",
      "priority": "high",
      "priority_display": "High",
      "status": "pending",
      "status_display": "Pending",
      "attachment": "/media/complaints/image.jpg",
      "admin_response": null,
      "responded_by": null,
      "response_date": null,
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z",
      "resolved_at": null
    }
  ]
}
```

**POST - Request Body:**

```json
{
  "subject": "Room maintenance issue",
  "description": "The AC in my room is not working properly for the past 3 days.",
  "category": "property",
  "priority": "high",
  "daklia": 5,
  "attachment": "[file - optional]"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `subject` | string | Yes | Complaint subject (min 5 chars) |
| `description` | string | Yes | Detailed description (min 10 chars) |
| `category` | string | No | Category code (default: "other") |
| `priority` | string | No | Priority level (default: "medium") |
| `daklia` | integer | No | Related Daklia ID |
| `attachment` | file | No | Supporting document/image |

**Category Options:**

| Value | Display |
|-------|---------|
| `booking` | Booking Issue |
| `payment` | Payment Issue |
| `property` | Property Issue |
| `service` | Service Issue |
| `staff` | Staff Behavior |
| `technical` | Technical Issue |
| `other` | Other |

**Priority Options:**

| Value | Display |
|-------|---------|
| `low` | Low |
| `medium` | Medium |
| `high` | High |
| `urgent` | Urgent |

**POST Response (201 Created):**

```json
{
  "message": "Complaint submitted successfully",
  "data": {
    "complaint_id": 1,
    "subject": "Room maintenance issue",
    "status": "pending",
    ...
  }
}
```

---

### 11.2 Get Complaint Details

**Endpoint:** `GET /api/v1/feedback/complaints/<complaint_id>/`

**Authentication:** Required

**Response (200 OK):**

```json
{
  "message": "Complaint retrieved successfully",
  "data": {
    "complaint_id": 1,
    "subject": "Room maintenance issue",
    "description": "The AC in my room is not working properly",
    "category": "property",
    "priority": "high",
    "status": "in_progress",
    "admin_response": "We have assigned a technician to look into this.",
    "responded_by_name": "admin_user",
    "response_date": "2024-01-16T09:00:00Z",
    "comments": [
      {
        "comment_id": 1,
        "user_name": "john_doe",
        "comment": "When will the technician arrive?",
        "is_admin_comment": false,
        "created_at": "2024-01-16T10:00:00Z"
      },
      {
        "comment_id": 2,
        "user_name": "admin_user",
        "comment": "The technician will arrive tomorrow between 10-12 AM.",
        "is_admin_comment": true,
        "created_at": "2024-01-16T11:00:00Z"
      }
    ],
    ...
  }
}
```

---

### 11.3 Add Comment to Complaint

**Endpoint:** `POST /api/v1/feedback/complaints/<complaint_id>/comment/`

**Authentication:** Required

**Request Body:**

```json
{
  "comment": "When will the technician arrive?",
  "attachment": "[file - optional]"
}
```

**Response (201 Created):**

```json
{
  "message": "Comment added successfully",
  "data": {
    "comment_id": 1,
    "complaint": 1,
    "user": 1,
    "user_name": "john_doe",
    "comment": "When will the technician arrive?",
    "is_admin_comment": false,
    "attachment": null,
    "created_at": "2024-01-16T10:00:00Z"
  }
}
```

**Error Response:**

| Status | Message |
|--------|---------|
| 400 | "Cannot add comments to a closed or rejected complaint" |

---

### 11.4 Cancel Complaint

**Endpoint:** `POST /api/v1/feedback/complaints/<complaint_id>/cancel/`

**Authentication:** Required

**Note:** Only pending complaints can be cancelled.

**Response (200 OK):**

```json
{
  "message": "Complaint cancelled successfully",
  "data": {
    "complaint_id": 1,
    "status": "closed",
    ...
  }
}
```

---

### 11.5 List/Create Suggestions

**Endpoint:** `GET /api/v1/feedback/suggestions/` | `POST /api/v1/feedback/suggestions/`

**Authentication:** Required

**GET - Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `status` | string | Filter by status |
| `category` | string | Filter by category |

**GET Response (200 OK):**

```json
{
  "message": "Suggestions retrieved successfully",
  "count": 3,
  "data": [
    {
      "suggestion_id": 1,
      "user": 1,
      "user_name": "john_doe",
      "title": "Add dark mode to the app",
      "description": "It would be great to have a dark mode option for the mobile app.",
      "category": "feature",
      "category_display": "New Feature",
      "status": "under_review",
      "status_display": "Under Review",
      "attachment": null,
      "admin_response": "Great suggestion! We are considering this for the next release.",
      "responded_by_name": "admin_user",
      "response_date": "2024-01-16T09:00:00Z",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-16T09:00:00Z"
    }
  ]
}
```

**POST - Request Body:**

```json
{
  "title": "Add dark mode to the app",
  "description": "It would be great to have a dark mode option for better visibility at night.",
  "category": "feature",
  "attachment": "[file - optional]"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | Yes | Suggestion title (min 5 chars) |
| `description` | string | Yes | Detailed description (min 10 chars) |
| `category` | string | No | Category code (default: "other") |
| `attachment` | file | No | Supporting document/image |

**Suggestion Category Options:**

| Value | Display |
|-------|---------|
| `feature` | New Feature |
| `improvement` | Improvement |
| `ui_ux` | UI/UX |
| `service` | Service |
| `property` | Property |
| `other` | Other |

**Suggestion Status Values:**

| Value | Display |
|-------|---------|
| `pending` | Pending Review |
| `under_review` | Under Review |
| `accepted` | Accepted |
| `implemented` | Implemented |
| `rejected` | Rejected |

---

### 11.6 Get Suggestion Details

**Endpoint:** `GET /api/v1/feedback/suggestions/<suggestion_id>/`

**Authentication:** Required

---

### 11.7 Delete Suggestion

**Endpoint:** `DELETE /api/v1/feedback/suggestions/<suggestion_id>/delete/`

**Authentication:** Required

**Note:** Only pending suggestions can be deleted.

**Response (204 No Content):**

```json
{
  "message": "Suggestion deleted successfully"
}
```

---

### 11.8 Get Complaint Categories

**Endpoint:** `GET /api/v1/feedback/complaints/categories/`

**Authentication:** Required

**Response (200 OK):**

```json
{
  "message": "Categories retrieved successfully",
  "data": [
    {"value": "booking", "label": "Booking Issue"},
    {"value": "payment", "label": "Payment Issue"},
    {"value": "property", "label": "Property Issue"},
    {"value": "service", "label": "Service Issue"},
    {"value": "staff", "label": "Staff Behavior"},
    {"value": "technical", "label": "Technical Issue"},
    {"value": "other", "label": "Other"}
  ]
}
```

---

### 11.9 Get Complaint Priorities

**Endpoint:** `GET /api/v1/feedback/complaints/priorities/`

**Authentication:** Required

**Response (200 OK):**

```json
{
  "message": "Priorities retrieved successfully",
  "data": [
    {"value": "low", "label": "Low"},
    {"value": "medium", "label": "Medium"},
    {"value": "high", "label": "High"},
    {"value": "urgent", "label": "Urgent"}
  ]
}
```

---

### 11.10 Get Suggestion Categories

**Endpoint:** `GET /api/v1/feedback/suggestions/categories/`

**Authentication:** Required

**Response (200 OK):**

```json
{
  "message": "Categories retrieved successfully",
  "data": [
    {"value": "feature", "label": "New Feature"},
    {"value": "improvement", "label": "Improvement"},
    {"value": "ui_ux", "label": "UI/UX"},
    {"value": "service", "label": "Service"},
    {"value": "property", "label": "Property"},
    {"value": "other", "label": "Other"}
  ]
}
```

---

## 12. Status Codes & Error Handling

### HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success (GET/PUT) |
| 201 | Created (POST) |
| 204 | No Content (DELETE) |
| 400 | Bad Request / Validation Error |
| 401 | Unauthorized (wrong password) |
| 403 | Forbidden (access denied) |
| 404 | Not Found |
| 500 | Internal Server Error |

### Error Response Format

All error responses include a `message` field:

```json
{
  "message": "Error description here"
}
```

Some errors include additional `code` field:

```json
{
  "message": "Access denied. You need an approved booking.",
  "code": "BOOKING_REQUIRED"
}
```

### Data Type Conversions

The API handles various data type representations:

| Type | Accepted Values |
|------|-----------------|
| Boolean | `"true"/"false"`, `"1"/"0"`, `"yes"/"no"`, `"on"/"off"` |
| Integer | String numbers converted automatically |
| Float | String decimals converted automatically |

---

## 13. Mobile App Flow

### Complete User Journey

```
1. REGISTRATION
   POST /api/v1/user/create
   ↓
2. VERIFY PHONE
   POST /api/v1/user/verify-code
   ↓
3. LOGIN
   POST /api/v1/user/login
   (Save token for all future requests)
   ↓
4. CREATE PROFILE
   POST /api/v1/person/register_student/
   OR
   POST /api/v1/person/register_employee/
   ↓
5. BROWSE PROPERTIES
   GET /api/v1/person/get-all-dakliaat/
   ↓
6. VIEW PROPERTY DETAILS
   GET /api/v1/daklia/daklia-profile/<id>/
   ↓
7. VIEW ROOMS
   GET /api/v1/daklia/<id>/rooms/
   ↓
8. VIEW ROOM DETAILS
   GET /api/v1/daklia/<daklia_id>/rooms/<room_id>/details/
   ↓
9. CREATE BOOKING
   POST /api/v1/person/create-new-booking/
   (Include invoice_receipt file)
   ↓
10. CHECK BOOKING STATUS
    GET /api/v1/person/bookings/<booking_id>/
    ↓
11. AFTER APPROVAL - GET CONTACT INFO
    GET /api/v1/daklia/daklia-sensitive/<id>/
    (Only available after booking approved)
```

### Password Recovery Flow

```
1. REQUEST OTP
   POST /api/v1/user/send-otp
   ↓
2. VERIFY OTP
   POST /api/v1/user/verify-code
   ↓
3. RESET PASSWORD
   PUT /api/v1/user/reset-password
```

### Daklia Owner Flow

```
1. REGISTER (user_type = 1)
   POST /api/v1/user/create
   ↓
2. CREATE DAKLIA
   POST /api/v1/daklia/daklia-info/
   ↓
3. SET LOCATION
   POST /api/v1/daklia/daklia-location/
   ↓
4. UPLOAD VERIFICATION DOCS
   POST /api/v1/daklia/verify-account/
   ↓
5. ADD ROOMS
   POST /api/v1/daklia/rooms/add/
   ↓
6. ADD ROOM FEATURES
   POST /api/v1/daklia/<id>/rooms/features/add/
   ↓
7. ADD SERVICES
   POST /api/v1/daklia/services/add/
   ↓
8. ADD RULES
   POST /api/v1/daklia/<id>/laws/add/
```

---

## File Upload Notes

### Supported Content Types

For endpoints with file uploads, use `multipart/form-data`:

```
Content-Type: multipart/form-data
```

### Supported File Types

- **Images:** JPG, PNG, GIF
- **Documents:** PDF
- **Max Size:** Check server configuration

### Example cURL for File Upload

```bash
curl -X POST \
  http://localhost:8000/api/v1/person/create-new-booking/ \
  -H "Authorization: Token your_token_here" \
  -F "room_id=1" \
  -F "student_id=1" \
  -F "start_date=2024-01-15" \
  -F "end_date=2024-01-30" \
  -F "total_price=500.0" \
  -F "transaction_id=TXN123456" \
  -F "invoice_receipt=@/path/to/receipt.pdf"
```

---

## Quick Reference

### Authentication Endpoints

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/v1/user/create` | No |
| POST | `/api/v1/user/login` | No |
| POST | `/api/v1/user/logout` | Yes |
| POST | `/api/v1/user/send-otp` | No |
| POST | `/api/v1/user/verify-code` | No |
| PUT | `/api/v1/user/change-password` | Yes |
| PUT | `/api/v1/user/reset-password` | No |

### Person Endpoints

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/v1/person/register_student/` | No |
| POST | `/api/v1/person/register_employee/` | No |

### Daklia Endpoints

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/v1/daklia/daklia-info/` | Yes |
| GET | `/api/v1/daklia/daklia-profile/<id>/` | Yes |
| GET | `/api/v1/daklia/daklia-sensitive/<id>/` | Yes |
| GET | `/api/v1/person/get-all-dakliaat/` | Yes |
| GET | `/api/v1/person/search-dakliaat/` | Yes |

### Room Endpoints

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/v1/daklia/rooms/add/` | Yes |
| GET | `/api/v1/daklia/<id>/rooms/` | Yes |
| GET | `/api/v1/daklia/<id>/rooms/<id>/details/` | Yes |
| PUT | `/api/v1/daklia/<id>/rooms/<id>/` | Yes |
| DELETE | `/api/v1/daklia/<id>/rooms/<id>/delete/` | Yes |

### Booking Endpoints

| Method | Endpoint | Auth |
|--------|----------|------|
| POST | `/api/v1/person/create-new-booking/` | Yes |
| GET | `/api/v1/person/bookings/<id>/` | Yes |
| POST | `/api/v1/person/bookings/<id>/cancel/` | Yes (Student/Employee/Owner) |
| GET | `/api/v1/person/owner/bookings/` | Yes (Owner) |
| POST | `/api/v1/person/owner/bookings/<id>/action/` | Yes (Owner) |

### Notification Endpoints

| Method | Endpoint | Auth |
|--------|----------|------|
| GET | `/api/v1/person/notifications/` | Yes |
| PATCH | `/api/v1/person/notifications/<id>/read/` | Yes |

### Feedback Endpoints (Complaints & Suggestions)

| Method | Endpoint | Auth |
|--------|----------|------|
| GET/POST | `/api/v1/feedback/complaints/` | Yes |
| GET | `/api/v1/feedback/complaints/<id>/` | Yes |
| POST | `/api/v1/feedback/complaints/<id>/comment/` | Yes |
| POST | `/api/v1/feedback/complaints/<id>/cancel/` | Yes |
| GET/POST | `/api/v1/feedback/suggestions/` | Yes |
| GET | `/api/v1/feedback/suggestions/<id>/` | Yes |
| DELETE | `/api/v1/feedback/suggestions/<id>/delete/` | Yes |
| GET | `/api/v1/feedback/complaints/categories/` | Yes |
| GET | `/api/v1/feedback/complaints/priorities/` | Yes |
| GET | `/api/v1/feedback/suggestions/categories/` | Yes |

---

*Last updated: February 2026*
