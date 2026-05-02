import QtQuick
import Quickshell
import qs.Widgets

NIconButtonHot {
    property ShellScreen screen
    property var pluginApi: null

    readonly property var main: pluginApi?.mainInstance ?? ({})
    readonly property real connectedCount: main.connectedCount ?? 0
    readonly property bool isLoading: main.isLoading ?? false

    icon: isLoading ? "reload" : connectedCount > 0 ? "shield-lock" : "shield"
    tooltipText: connectedCount > 0
        ? pluginApi?.tr("common.connected")
        : pluginApi?.tr("common.disconnected")

    onClicked: pluginApi?.togglePanel(screen, this)
}