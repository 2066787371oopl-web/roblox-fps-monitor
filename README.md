# Roblox实时FPS显示器

这是一个用于Roblox游戏的实时帧率监控脚本，支持颜色动态变化和设备适配。

## 功能特点
- 右上角实时显示FPS数值
- 根据帧率自动变色（绿/黄/红）
- 支持移动端/主机/PC多平台显示
- 显示当前用户名

## 使用方法
1. 在Roblox Studio中创建ScreenGui对象
2. 将本脚本放入ServerScriptService或StarterPlayerScripts
3. 运行游戏即可在右上角看到FPS显示

## 设备适配
- 自动检测移动端并缩小显示尺寸
- 主机平台显示在屏幕底部
