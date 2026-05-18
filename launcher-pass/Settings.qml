import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null

  property var cfg: pluginApi?.pluginSettings || ({})
  property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property string editStorePath: cfg.storePath ?? defaults.storePath ?? ""
  property string editTypeDelay: String(cfg.typeDelay ?? defaults.typeDelay ?? 0.2)
  property string editWtypeDelay: String(cfg.wtypeDelay ?? defaults.wtypeDelay ?? 12)

  spacing: Style.marginL

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.storePath.label") || "Password Store Path"
    description: pluginApi?.tr("settings.storePath.desc") || "Custom path to the password store (default: ~/.password-store)"
    text: root.editStorePath
    onTextChanged: root.editStorePath = text
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.typeDelay.label") || "Launcher Close Delay"
    description: pluginApi?.tr("settings.typeDelay.desc") || "Delay before typing starts (seconds, default: 0.2)"
    text: root.editTypeDelay
    onTextChanged: root.editTypeDelay = text
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.wtypeDelay.label") || "Wtype Keystroke Delay"
    description: pluginApi?.tr("settings.wtypeDelay.desc") || "Delay between keystrokes in ms (default: 12)"
    text: root.editWtypeDelay
    onTextChanged: root.editWtypeDelay = text
  }

  function saveSettings() {
    if (!pluginApi) return;
    pluginApi.pluginSettings.storePath = root.editStorePath;

    var typeDelayVal = parseFloat(root.editTypeDelay)
    pluginApi.pluginSettings.typeDelay = isNaN(typeDelayVal) || typeDelayVal < 0 ? 0.2 : typeDelayVal;

    var wtypeDelayVal = parseInt(root.editWtypeDelay)
    pluginApi.pluginSettings.wtypeDelay = isNaN(wtypeDelayVal) || wtypeDelayVal < 0 ? 12 : wtypeDelayVal;

    pluginApi.saveSettings();
  }
}