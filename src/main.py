import os
import sys
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from threading import Thread
from PyQt6.QtCore import QUrl, QCoreApplication
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtWebEngineQuick import QtWebEngineQuick

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PUBLIC_DIR = os.path.join(BASE_DIR, "public")
UI_MAIN = os.path.join(BASE_DIR, "ui", "main.qml")


class _CwdHandler(SimpleHTTPRequestHandler):
    def translate_path(self, path: str) -> str:  # type: ignore[override]
        # 将根目录固定为 PUBLIC_DIR
        path = super().translate_path(path)
        rel = os.path.relpath(path, os.getcwd())
        return os.path.join(PUBLIC_DIR, rel)


def start_http_server(port: int) -> ThreadingHTTPServer:
    httpd = ThreadingHTTPServer(("127.0.0.1", port), _CwdHandler)
    t = Thread(target=httpd.serve_forever, daemon=True)
    t.start()
    return httpd


def main() -> None:
    QCoreApplication.setApplicationName("QML-Cesium")
    QCoreApplication.setOrganizationName("Local")

    os.environ.setdefault("QTWEBENGINE_REMOTE_DEBUGGING", "9222")

    QtWebEngineQuick.initialize()

    # 启动本地 HTTP 服务器，避免 file:// 引起的跨域/Referer 限制
    port = 5500
    server = start_http_server(port)
    http_index_url = f"http://127.0.0.1:{port}/index.html"

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # 将 URL 注入为 QML 上下文属性
    engine.rootContext().setContextProperty("WEB_INDEX_URL", http_index_url)

    url = QUrl.fromLocalFile(UI_MAIN)
    engine.load(url)

    if not engine.rootObjects():
        sys.exit(1)
    try:
        sys.exit(app.exec())
    finally:
        try:
            server.shutdown()
        except Exception:
            pass


if __name__ == "__main__":
    main()
