import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root

    property var pluginApi: null

    readonly property var ps: pluginApi?.pluginSettings ?? ({})

    spacing: Style.marginM

    // ── Bar metric ───────────────────────────────────────────────
    NComboBox {
        id: barMetricCombo
        Layout.fillWidth: true
        label: "Bar metric"
        description: "What the bar pill displays"
        model: [
            { key: "auto",    name: "Auto (session % or cost)" },
            { key: "session", name: "Session %"                },
            { key: "weekly",  name: "Weekly %"                 },
            { key: "cost",    name: "Cost ($)"                 }
        ]
        currentKey: ps.barMetric ?? "auto"
    }

    // ── Display mode ─────────────────────────────────────────────
    NToggle {
        id: displayToggle
        Layout.fillWidth: true
        label: "Always show in bar"
        description: "Keep pill visible even when idle"
        checked: (ps.displayMode ?? "alwaysShow") === "alwaysShow"
    }

    // ── Refresh interval ─────────────────────────────────────────
    NComboBox {
        id: pollCombo
        Layout.fillWidth: true
        label: "Refresh interval"
        description: "How often to re-read usage data"
        model: [
            { key: "30000",  name: "30 seconds" },
            { key: "60000",  name: "1 minute"   },
            { key: "300000", name: "5 minutes"  },
            { key: "900000", name: "15 minutes" }
        ]
        currentKey: String(ps.pollInterval ?? 60000)
    }

    // ── Daily budget ─────────────────────────────────────────────
    NTextInput {
        id: budgetInput
        Layout.fillWidth: true
        label: "Daily budget ($)"
        description: "Pill colour ramp activates above 50%. Set to 0 to disable."
        text: String(ps.dailyBudget ?? 0)
    }

    function saveSettings() {
        if (!pluginApi) return;
        const b = parseFloat(budgetInput.text);
        pluginApi.pluginSettings.barMetric    = barMetricCombo.currentKey;
        pluginApi.pluginSettings.displayMode  = displayToggle.checked ? "alwaysShow" : "alwaysHide";
        pluginApi.pluginSettings.pollInterval = parseInt(pollCombo.currentKey, 10) || 60000;
        pluginApi.pluginSettings.dailyBudget  = (Number.isFinite(b) && b >= 0) ? b : 0;
        pluginApi.saveSettings();
    }
}
