//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

import QtQuick 2.11
import QtQuick.Controls 2.4
import JASP.Theme 1.0

Item
{
	id:				jaspRibbon
	objectName:		"jaspRibbon"
	implicitWidth:	ribbonRow.width + ribbonRow.spacing
	implicitHeight:	60 * ppiScale


	property var	model:			null
	property bool	separateMe:		false
	property bool	ribbonEnabled:	true
	property bool	highlighted:	false
	property string	module:			"???"

	Rectangle
	{
		id:			highlighter

		z:			-1
		x:			inBetweenRibbons.visible ? inBetweenRibbons.width + ribbonRow.spacing : 0
		width:		ribbonRow.width - x
		height:		parent.height - (Theme.ribbonButtonPadding)

		color:		Theme.blueLighter
		//radius:		20
		visible:	jaspRibbon.highlighted

		anchors.verticalCenter: parent.verticalCenter
	}

	Row
	{
		id				: ribbonRow
		objectName		: "ribbonRow"
		spacing			: 10 * ppiScale

		anchors.verticalCenter: parent.verticalCenter

		ToolSeparator
		{
			id:						inBetweenRibbons
			height:					Theme.ribbonButtonHeight
			visible:				jaspRibbon.separateMe
			anchors.verticalCenter: parent.verticalCenter

			MouseArea
			{
				z				: 1
				anchors.fill	: parent
				hoverEnabled	: true
				acceptedButtons	: Qt.NoButton
				cursorShape		: Qt.OpenHandCursor
			}
		}

		Repeater
		{
			id      : tabs
			model   : jaspRibbon.model
			delegate: Loader
			{
				anchors.verticalCenter	: parent.verticalCenter
				sourceComponent			: displayText === "???" ? toolSeparator : ribbonButtonDelegate

				property int ribbonIndex: index

				Component
				{
					id: ribbonButtonDelegate

					RibbonButton
					{
						text   :	displayText
						source :	(jaspRibbon.model.isDynamic ? "file:" : "qrc:/icons/") + iconSource
						menu   :	analysisMenu
						enabled:	jaspRibbon.model.enabled && (!jaspRibbon.model.requiresDataset || mainWindow.datasetLoaded)
						moduleName: jaspRibbon.module
					}
				}

				Component
				{
					id: toolSeparator

					ToolSeparator
					{
						height: Theme.ribbonButtonHeight

						MouseArea
						{
							z				: 0
							anchors.fill	: parent
							hoverEnabled	: true
							acceptedButtons	: Qt.NoButton
							cursorShape		: Qt.OpenHandCursor
						}
					}
				}
			}
		}
	}
}
