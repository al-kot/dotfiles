import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Widgets


PanelWindow {
    id: root

    FontLoader {
        id: monoBold
        source: "file:///usr/share/fonts/TTF/MononokiNerdFontMono-Bold.ttf"
    }

    readonly property var colors: ({
        fg: {
            normal: "#ebdbb2",
            inactive: "#a89984"
        }
    })

    component CustomText: Item {
        property alias text: label.text
        property alias font: label.font
        property alias color: label.color
        width: label.width
        height: label.height
        Text {
            id: label
            height: 25
            color: colors.fg.normal
            font {
                family: monoBold
                bold: true
                pixelSize: 14
            }
        }
        DropShadow {
            anchors.fill: label
            source: label
            horizontalOffset: 0
            verticalOffset: 1
            radius: 8
            spread: 0.2
            samples: 12           // Higher samples = smoother shadow
            color: "#8F000000"   // 0.56 alpha in hex (approx #8F)
        }
    }

    

    anchors {
        top: true
        left: true
        right: true
    }

    margins.top: 12


    color: 'transparent'

    implicitHeight: 20

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 20
            rightMargin: 20
        }
        spacing: 0

        Row {
            spacing: 25
            Layout.alignment: Qt.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            Repeater {
                model: Hyprland.workspaces.values
                CustomText {
                    text: modelData.name.toUpperCase()
                    color: modelData.focused ? colors.fg.normal : colors.fg.inactive
                }
            }
        }

        Item { Layout.fillWidth: true }
        
        Row {
            spacing: 15
            anchors.centerIn: parent
            Layout.alignment: Qt.AlignCenter
            anchors.verticalCenter: parent.verticalCenter
            CustomText {
                id: clock
                text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
            }
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
            }
        }

        Item { Layout.fillWidth: true }
        
        Row {
            spacing: 25
            Layout.alignment: Qt.AlignRight
            anchors.verticalCenter: parent.verticalCenter

            // df / --output=avail --block-size=1G | tail -1 | tr -d ' '
            CustomText { id: diskUsage }
            Process {
                id: diskProc
                command: ["sh", "-c", "df / --output=avail --block-size=1G | tail -1 | tr -d ' '"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: diskUsage.text = "" + this.text.trim().padStart(4, "\u2007") + " GB"
                }
            }

            CustomText { id: cpuUsage }
            Process {
                id: cpuProc
                command: ["sh", "-c", "grep 'cpu ' /proc/stat | awk '{u=$2;n=$3;s=$4;i=$5;w=$6;x=$7;y=$8;z=$9; t=u+n+s+i+w+x+y+z; id=i+w; print t, id}' | (read t1 i1; sleep 0.1; grep 'cpu ' /proc/stat | awk -v t1=$t1 -v i1=$i1 '{u=$2;n=$3;s=$4;i=$5;w=$6;x=$7;y=$8;z=$9; t=u+n+s+i+w+x+y+z; id=i+w; print int(100*(1-(id-i1)/(t-t1)))}')"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: cpuUsage.text = "" + this.text.trim().padStart(4, "\u2007") + "%"
                }
            }

            CustomText { id: ramUsage }
            Process {
                id: ramProc
                command: ["sh", "-c", "free -b | awk '/Mem:/ {printf \"%.2f\", ($2 - $7) / 1024^3}'"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: {
                        ramUsage.text = "" + this.text.trim().padStart(6, "\u2007") + " GiB"
                    }
                }
            }


            CustomText { id: gpuUsage }
            Process {
                id: gpuProc
                command: ["sh", "-c", "nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits | awk -F', ' '{printf \"%.2f\", $1 / 1024}'"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: gpuUsage.text = "󰢮" + this.text.trim().padStart(6, "\u2007") + " GiB"
                }
            }
            Process { id: volAdjust }
            Process {
                id: volProc
                command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\\d+(?=%)' | head -1"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: volume.text = "" + this.text.trim().padStart(4, "\u2007") + "%"
                }
            }
            CustomText {
                id: volume

                MouseArea {
                    anchors.fill: parent
                    onWheel: (wheel) => {
                        volAdjust.command = ['sh', '-c', 'pactl set-sink-volume @DEFAULT_SINK@ %1'.arg(wheel.angleDelta.y > 0 ? '+1%' : '-1%')]
                        volAdjust.running = true
                        volProc.running = true
                    }
                }
            }

            Timer {
                interval: 2000; running: true; repeat: true
                onTriggered: {
                    diskProc.running = true
                    cpuProc.running = true
                    ramProc.running = true
                    gpuProc.running = true
                    volProc.running = true
                }
            }
        }
    }

}
