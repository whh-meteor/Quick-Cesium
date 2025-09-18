# QML-Cesium

PyQt6 + QML + Qt WebEngine (CesiumJS) 示例。

## 运行

- Windows 一键运行：双击 `run_dev.bat`
- 或手动：
  1. 创建虚拟环境并安装依赖：
     ```bash
     python -m venv .venv
     .venv\\Scripts\\activate
     pip install -r requirements.txt
     ```
  2. 启动：
     ```bash
     python .\\src\\main.py
     ```

若网络较慢，可将 `public/index.html` 中的 Cesium CDN 替换为本地路径。
