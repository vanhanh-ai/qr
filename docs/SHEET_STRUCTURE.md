# 📊 Cấu trúc Google Sheets (Database)

Để hệ thống hoạt động, bạn cần tạo một Google Sheet với các bảng (Tabs) và cấu trúc cột như sau:

## 1. Sheet: `Users`
Dùng để quản lý tài khoản đăng nhập.
- **Cột A**: `Username`
- **Cột B**: `PIN` (Mật khẩu số)
- **Cột C**: `Role` (Admin/User)

## 2. Sheet: `Devices`
Danh mục thiết bị/tài sản.
- **Cột A**: `UID` (Mã định danh duy nhất)
- **Cột B**: `Name` (Tên thiết bị)
- **Cột C**: `Location` (Vị trí)
- **Cột D**: `Specs` (Thông số kỹ thuật)
- **Cột E**: `Cycle` (Chu kỳ bảo trì - số ngày)
- **Cột F**: `NextMaintenance` (Ngày bảo trì tiếp theo)
- **Cột G**: `Status` (Trạng thái hiện tại: IN/OUT)

## 3. Sheet: `Logs`
Nhật ký bảo trì và lịch sử Nhập/Xuất.
- **Cột A**: `Timestamp` (Thời gian)
- **Cột B**: `AssetUID`
- **Cột C**: `Data` (Dữ liệu Checklist dạng JSON)
- **Cột D**: `Notes` (Ghi chú)
- **Cột E**: `User` (Người thực hiện)
- **Cột F**: `ImageURL` (Link ảnh trên Drive)

## 4. Sheet: `Checklists`
Cấu hình các đầu việc kiểm tra động.
- **Cột A**: `Type` (Loại thiết bị: default, hvac, v.v.)
- **Cột B**: `ID` (Mã đầu việc: c1, c2...)
- **Cột C**: `Title` (Tên đầu việc)
- **Cột D**: `Description` (Mô tả chi tiết)

## 5. Sheet: `WorkOrders`
Quản lý các phiếu sửa chữa/bảo trì.
- **Cột A**: `WO-ID`
- **Cột B**: `Timestamp`
- **Cột C**: `AssetUID`
- **Cột D**: `Status` (Open/Closed/In Progress)
- **Cột E**: `Priority`
- **Cột F**: `Type`
- **Cột G**: `Description`
- **Cột H**: `DueDate`

## 6. Sheet: `AuditLog`
Ghi nhật ký hệ thống và thay đổi mật khẩu.
- **Cột A**: `Timestamp`
- **Cột B**: `User`
- **Cột C**: `Action`
- **Cột D**: `Target`
- **Cột E**: `Details`
