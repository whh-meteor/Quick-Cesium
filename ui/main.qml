import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtWebEngine 1.10

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 800
    title: "QML + Cesium (Qt WebEngine)"

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            Label { text: root.title; Layout.alignment: Qt.AlignVCenter }
            Item { Layout.fillWidth: true }
            Button { text: "刷新"; onClicked: web.reload() }
        }
    }

    // 由 Python 设置的上下文属性 WEB_INDEX_URL（为 http://127.0.0.1:<port>/index.html）
    property url httpIndexUrl: typeof WEB_INDEX_URL !== 'undefined' && WEB_INDEX_URL ? WEB_INDEX_URL : ""

    WebEngineView {
        id: web
        anchors.fill: parent
        url: httpIndexUrl || Qt.resolvedUrl("../public/index.html")
        profile: WebEngineProfile {
            httpUserAgent: "QML-Cesium/1.0"
            persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
        }
        settings.javascriptEnabled: true
        settings.webGLEnabled: true
        settings.localStorageEnabled: true
        settings.localContentCanAccessFileUrls: true
        settings.localContentCanAccessRemoteUrls: true

        onLoadingChanged: function(loadRequest){
            if (loadRequest.status === WebEngineView.LoadStartedStatus)
                console.log("[Web] Load started:", loadRequest.url)
            if (loadRequest.status === WebEngineView.LoadSucceededStatus)
                console.log("[Web] Load success:", loadRequest.url)
            if (loadRequest.status === WebEngineView.LoadFailedStatus)
                console.log("[Web] Load failed:", loadRequest.errorString)
        }

        onJavaScriptConsoleMessage: function(level, message, lineNumber, sourceId) {
            console.log("[JS]", sourceId + ":" + lineNumber, message)
        }
    }
}
