# Android 环境搭建与模拟器配置指南

由于当前的终端环境没有管理员权限，无法自动安装 Android Studio。请按照以下步骤手动完成环境搭建。

## 第一步：安装 Android Studio
您可以选择以下任一方式进行安装：

### 方式 A：使用命令行 (推荐)
打开 PowerShell (以管理员身份运行)，执行以下命令：
```powershell
winget install Google.AndroidStudio
```

### 方式 B：手动下载
1. 访问官网：[https://developer.android.com/studio](https://developer.android.com/studio)
2. 下载适用于 Windows 的最新版安装包。
3. 运行安装程序，确保勾选 **"Android Virtual Device"** 组件。

---

## 第二步：初始化设置
1. 安装完成后，启动 Android Studio。
2. 首次启动时会弹出设置向导 (Setup Wizard)。
3. 选择 **"Standard"** (标准) 安装类型。
4. 向导会自动下载必要的 SDK 组件（包括 Android SDK Platform, API, Build-Tools 等）。
   > **注意**：请记住 SDK 的安装路径（通常是 `C:\Users\您的用户名\AppData\Local\Android\Sdk`）。

## 第三步：创建虚拟设备 (AVD)
1. 在 Android Studio 欢迎界面，点击 **"More Actions"** -> **"Virtual Device Manager"**。
   *(如果已经进入主界面，点击右上角的手机图标 "Device Manager")*
2. 点击 **"Create device"**。
3. **Select Hardware**:
   - 选择 **"Phone"** -> **"Pixel 7"** (或其他带 Play Store 图标的设备)。
   - 点击 Next。
4. **System Image**:
   - 选择一个推荐的系统镜像（例如 **Release Name: 34** 或 **35**）。
   - 如果旁边有下载图标，请先点击下载。
   - 点击 Next。
5. **Verify Configuration**:
   - AVD Name: 可以保持默认或修改为易记的名字（如 `Pixel_7_API_34`）。
   - Graphics: 建议选择 **"Hardware - GLES 2.0"** 以获得更好性能。
   - 点击 **Finish**。

## 第四步：验证环境
配置完成后，回到 VS Code 或 Trae 的终端，运行以下命令验证：

```bash
flutter config --android-sdk "C:\Users\您的用户名\AppData\Local\Android\Sdk"
flutter doctor
```
*(请将路径替换为实际的 SDK 安装路径)*

如果一切正常，`flutter doctor` 的 Android 栏目应该会显示全绿 [√]。
