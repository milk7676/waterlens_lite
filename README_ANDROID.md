# Android 移植与发布指南

本文档详细说明了将 WaterLens Lite 移植到 Android 平台的配置变更、编译步骤及测试注意事项。

## 1. 环境准备
确保您的开发环境已安装以下工具：
- Flutter SDK (>= 3.4.0)
- Java Development Kit (JDK) 17
- Android Studio & Android SDK Command-line Tools

## 2. 所做的变更
为了适配 Android 平台，我们进行了以下调整：

### 权限配置 (AndroidManifest.xml)
我们添加了以下必要权限：
- **INTERNET**: 用于加载高德地图瓦片数据。
- **ACCESS_FINE_LOCATION / COARSE_LOCATION**: 用于在地图上显示“我的位置”。
- **CAMERA**: 用于现场拍照核查。
- **READ/WRITE_EXTERNAL_STORAGE**: 用于导入导出数据（兼容旧版 Android）。

### 依赖项 (pubspec.yaml)
- 新增 `geolocator: ^13.0.0`: 用于获取设备当前 GPS 位置。

### 功能增强
- **地图页**: 新增了“我的位置”按钮，点击可请求定位权限并移动地图中心到当前位置。
- **界面适配**: 审计页面的输入框布局已优化，适配移动端屏幕宽度。

## 3. 编译与发布
### 生成发布版 APK
在项目根目录下运行终端命令：

```bash
flutter build apk --release
```

编译完成后，APK 文件位于：
`build/app/outputs/flutter-apk/app-release.apk`

### 生成 App Bundle (推荐用于 Google Play)
```bash
flutter build appbundle --release
```

## 4. 安装与测试
### 安装到真机
1. 开启手机的“开发者模式”和“USB 调试”。
2. 连接手机到电脑。
3. 运行命令：
   ```bash
   flutter install
   ```
   或者直接将 `app-release.apk` 发送到手机进行安装。

### 测试重点
1. **地图加载**: 确保在有网络的情况下地图瓦片能正常显示。
2. **定位功能**: 点击右下角“我的位置”按钮，检查是否弹出权限请求，并能定位成功。
3. **拍照/相册**: 在核查页点击“拍照”或“相册”，检查是否能正常获取图片。
4. **文件导入/导出**: 测试导入 GeoJSON/Excel 文件及导出功能是否正常。

## 5. 常见问题
- **地图不显示**: 请检查手机网络权限是否允许该应用联网。
- **定位失败**: 请确保手机 GPS 已开启，且已授权应用获取位置信息。
- **导出失败**: Android 10+ 系统对文件读写有限制，建议使用系统文件选择器保存到“下载”目录。
