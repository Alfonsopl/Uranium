import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import UM 1.0 as UM

Item {
    id: base;

    property string name;
    property string description;
    property variant value;
    property string unit;
    property int valid;
    property string type;

    property variant options;
    property int index;
    property variant key;

    signal contextMenuRequested();
    signal itemValueChanged(variant value);
    signal showTooltip(variant position);
    signal hideTooltip();

    property variant style: SettingItemStyle { }

    Label
    {
        id: label;

        anchors.left: parent.left;
        anchors.right: controlContainer.left;
        anchors.rightMargin: base.style.spacing;

        height: base.style.fixedHeight > 0 ? base.style.fixedHeight : parent.height;

        horizontalAlignment: Text.AlignRight;
        verticalAlignment: Text.AlignVCenter;

        text: base.name
        elide: Text.ElideMiddle;

        color: base.style.labelColor;
        font: base.style.labelFont;

        MouseArea {
            id: mouse;

            anchors.fill: parent;

            acceptedButtons: Qt.LeftButton | Qt.RightButton;

            hoverEnabled: true;

            onClicked: {
                if(mouse.button == Qt.LeftButton)
                {
                    base.clicked(mouse)
                }
                else
                {
                    base.contextMenuRequested();
                }
            }

            onEntered: {
                hoverTimer.start();
            }

            onExited: {
                hoverTimer.stop();
                base.hideTooltip();
            }

            Timer {
                id: hoverTimer;
                interval: 500;
                repeat: false;

                onTriggered: base.showTooltip({ x: mouse.mouseX, y: mouse.mouseY });
            }
        }
    }

    Loader {
        id: controlContainer;

        anchors.right: parent.right;
        anchors.rightMargin: base.style.controlRightMargin;

        width: base.style.controlWidth;
        height: base.style.fixedHeight > 0 ? base.style.fixedHeight : parent.height;

        property variant itemStyle: base.style;

        source:
        {
            switch(base.type)
            {
                case "int":
                    return "SettingTextField.qml"
                case "float":
                    return "SettingTextField.qml"
                case "double":
                    return "SettingTextField.qml"
                case "enum":
                    return "SettingComboBox.qml"
                case "boolean":
                    return "SettingCheckBox.qml"
                default:
                    return "SettingUnknown.qml"
            }
        }

        Connections {
            target: controlContainer.item;
            onValueChanged: {
                base.itemValueChanged(value);
            }
        }
    }
}
