/*
 * Copyright (C) 2013 Canonical, Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import "../Components"

DashRenderer {
    id: root

    readonly property int collapsedRows: {
        if (!cardTool || !cardTool.template || typeof cardTool.template["collapsed-rows"] != "number") return 2;
        return cardTool.template["collapsed-rows"];
    }

    expandedHeight: grid.totalContentHeight
    collapsedHeight: Math.min(grid.contentHeightForRows(collapsedRows), expandedHeight)
    originY: grid.originY

    ResponsiveGridView {
        id: grid
        anchors.fill: parent
        minimumHorizontalSpacing: units.gu(1)
        delegateWidth: cardTool.cardWidth
        delegateHeight: cardTool.cardHeight
        verticalSpacing: units.gu(1)
        model: root.model
        displayMarginBeginning: root.displayMarginBeginning
        displayMarginEnd: root.displayMarginEnd
        cacheBuffer: 0
        interactive: false
        delegate: Item {
            width: grid.cellWidth
            height: grid.cellHeight
            Loader {
                id: loader
                sourceComponent: cardTool.cardComponent
                anchors.horizontalCenter: parent.horizontalCenter
                onLoaded: {
                    item.objectName = "delegate" + index;
                    item.width = Qt.binding(function() { return cardTool.cardWidth; });
                    item.height = Qt.binding(function() { return cardTool.cardHeight; });
                    item.fixedArtShapeSize = Qt.binding(function() { return cardTool.artShapeSize; });
                    item.cardData = Qt.binding(function() { return model; });
                    item.template = Qt.binding(function() { return cardTool.template; });
                    item.components = Qt.binding(function() { return cardTool.components; });
                    item.headerAlignment = Qt.binding(function() { return cardTool.headerAlignment; });
                    item.scopeStyle = root.scopeStyle;
                }
                Connections {
                    target: loader.item
                    onClicked: root.clicked(index, result)
                    onPressAndHold: root.pressAndHold(index)
                }
            }
        }
    }
}